require File.join( File.dirname(File.dirname(__FILE__)), 'test_helper' )

class ProductTest < ActiveSupport::TestCase

  subject { @product = Factory :product }

  should_allow_values_for       :barcode, "1231 abC 123", "2064-24503-2", "6 410500 046431"
  should_not_allow_values_for   :barcode, "1231 ABC 123!", "|2064-24503-2"
  should_validate_uniqueness_of :barcode  

  should_allow_values_for     :kind, "food", "drink"
  should_not_allow_values_for :kind, "bar"
  
  should_ensure_value_in_range :energy,  0..10000
  should_ensure_value_in_range :portion, 0..1000
  
  should_ensure_value_in_range :protein,      0..100
  should_ensure_value_in_range :carbohydrate, 0..100
  should_ensure_value_in_range :sugar,        0..100
  should_ensure_value_in_range :fat,          0..100
  should_ensure_value_in_range :saturate,     0..100
  should_ensure_value_in_range :fibre,        0..100
  should_ensure_value_in_range :salt,         0..100
  should_ensure_value_in_range :sodium,       0..100
  should_ensure_value_in_range :added_sugar,  0..100

  context "barcode input" do
    should "upcase" do
      product = Product.new :barcode => "aBce"    
      assert_equal "ABCE", product.barcode
    end
    
    should "remove spaces and hyphens" do
      product = Product.new :barcode => "12 3-4"      
      assert_equal "1234", product.barcode
    end
  end
  
  context "per_portion method" do
    should "return only values that are present" do
      missing = {:fibre => nil, :protein => nil, :fat => nil, :sodium => nil}
      @product = Factory.build :product, missing
      
      (@product.ingredients - missing.keys).each {|present_ingredient|
        assert @product.per_portion[present_ingredient], "Expected :#{present_ingredient} to be present in #{@product.per_portion.inspect}"
      }
      
      missing.keys.each {|missing|
        assert @product.per_portion[missing].nil?
      }
    end
    
    should "return correct number" do
      @product = Factory.build :product, :portion => 50, :fat => 5
      
      assert_equal 2.5, @product.per_portion[:fat]
    end
  end

  context "validating salt and sodium" do
    
    context "if only sodium is available" do
      should "be valid" do
        assert Factory.build(:product, :sodium => 0.1, :salt => nil).valid?
      end
      
      should "use sodium for calculations" do
        assert_equal :low,    Factory.build(:product, :sodium => 0.1, :salt => nil).fsa[:salt]
        # sodium 0.2g should be multiplied by 2.5 to give equivalent salt - this will make it > 0.30g and therefore medium
        assert_equal :medium, Factory.build(:product, :sodium => 0.2, :salt => nil).fsa[:salt]
        assert_equal :high,   Factory.build(:product, :sodium => 0.7, :salt => nil).fsa[:salt]
      end
    end
    
    context "if only salt is available" do
      should "be valid" do
        Factory.build(:product, :sodium => nil, :salt => 0.30).valid?
      end
      
      should "use salt for calculations" do
        assert_equal :low,    Factory.build(:product, :sodium => nil, :salt => 0.30).fsa[:salt]
        assert_equal :medium, Factory.build(:product, :sodium => nil, :salt => 1.00).fsa[:salt]
        assert_equal :high,   Factory.build(:product, :sodium => nil, :salt => 1.51).fsa[:salt]
      end
    end
    
    context "if both are available" do
      should "be valid" do
        assert (Factory.build(:product, :sodium => 0.3, :salt => 1)).valid?
      end
      
      should "use sodium for calculations" do
        assert_equal :low,    Factory.build(:product, :sodium => 0.1, :salt => 0.25).fsa[:salt]
        # sodium 0.2g should be multiplied by 2.5 to give equivalent salt - this will make it > 0.30g and therefore medium
        assert_equal :medium, Factory.build(:product, :sodium => 0.2, :salt => 0.25).fsa[:salt]
        assert_equal :high,   Factory.build(:product, :sodium => 0.7, :salt => 0.25).fsa[:salt]
      end
    end
    
    context "if neither are available" do
      should "not be valid" do
        assert !(Factory.build(:product, :sodium => nil, :salt => nil)).valid?
      end
    end
    
  end

  context "validating added_sugar" do  
    context "when added_sugar is not present" do
      should "be invalid if total sugar is greater than 5g" do
        @product = Factory.build :product, :sugar => 6, :added_sugar => nil
        assert !@product.valid?
      end
    
      should "be valid if total sugar is =< 5g" do
        @product = Factory.build :product, :sugar => 5, :added_sugar => nil
        assert @product.valid?
      end
    end
    
    context "when added_sugar is present" do
      should "be invalid if greater than total sugar" do
        @product = Factory.build :product, :sugar => 6, :added_sugar => 7
        assert !@product.valid?
      end
      
      should "be invalid if greater than 100 even if total sugar <= 5" do
        @product = Factory.build :product, :sugar => 4, :added_sugar => 120
        assert !@product.valid?
      end
      
      should "be valid if =< than total sugar" do
        @product = Factory.build :product, :sugar => 6, :added_sugar => 6
        assert @product.valid?
      end
    end
  end
  
  context "FSA Traffic light signpost labelling for" do
    context "drink" do
      context "testing sugar" do
        should "be low for <= 2.5" do
          assert_equal :low, Factory.build(:product, :kind => 'drink', :sugar => 2.5).fsa[:sugar]
        end
        
        should "be medium for 2.5 to 6.3" do
          assert_equal :medium, Factory.build(:product, :kind => 'drink', :sugar => 8, :added_sugar => 0).fsa[:sugar]
          assert_equal :medium, Factory.build(:product, :kind => 'drink', :sugar => 8, :added_sugar => 6.3).fsa[:sugar]
        end
        
        should "be high for > 6.3" do
          assert_equal :high, Factory.build(:product, :kind => 'drink', :sugar => 6.4, :added_sugar => 6.4).fsa[:sugar]
        end
      end
      
      context "testing fat" do
        should "be low for fat <= 1.5" do
          assert_equal :low, Factory.build(:product, :kind => 'drink', :fat => 0.75).fsa[:fat]
        end
        
        should "be medium for 1.5 to 10" do
          assert_equal :medium, Factory.build(:product, :kind => 'drink', :fat => 10).fsa[:fat]
        end
        
        should "be high for > 10" do
          assert_equal :high, Factory.build(:product, :kind => 'drink', :fat => 11).fsa[:fat]
        end
      end
      
      context "testing saturate" do
        should "be low for <= 0.75" do
          assert_equal :low, Factory.build(:product, :kind => 'drink', :saturate => 0.75).fsa[:saturate]
        end
        
        should "be medium for 0.75 to 2.5" do
          assert_equal :medium, Factory.build(:product, :kind => 'drink', :saturate => 1.75).fsa[:saturate]
        end
        
        should "be high for > 2.5" do
          assert_equal :high, Factory.build(:product, :kind => 'drink', :saturate => 2.6).fsa[:saturate]
        end
      end
      
      context "testing salt" do
        should "be low for < 0.3" do
          assert_equal :low, Factory.build(:product, :kind => 'drink', :salt => 0.3).fsa[:salt]
        end
        
        should "be medium for 0.3 to 1.5" do
          assert_equal :medium, Factory.build(:product, :kind => 'drink', :salt => 0.75).fsa[:salt]
        end
        
        should "be high for > 1.5" do
          assert_equal :high, Factory.build(:product, :kind => 'drink', :salt => 1.51).fsa[:salt]
        end
      end
    end
    
    context "food" do
      context "testing sugar" do
        should "be low for < 5 sugar" do
          assert_equal :low, Factory.build(:product, :sugar => 4).fsa[:sugar]
        end
        
        should "be high for portion > 100g and added_sugar > 15g / portion" do
          assert_equal :high, Factory.build(:product, :portion => 101, :sugar => 16, :added_sugar => 16).fsa[:sugar]
        end
        
        should "be high for portion > 100g and added_sugar < 15g / portion but added_sugar > 12.5 / 100g" do
          assert_equal :high, Factory.build(:product, :portion => 101, :sugar => 14, :added_sugar => 14).fsa[:sugar]
        end
        
        should "be medium for portion > 100g and added_sugar < 15g / portion and added_sugar < 12.5 / 100g" do
          assert_equal :medium, Factory.build(:product, :portion => 101, :sugar => 12, :added_sugar => 12).fsa[:sugar]
        end
        
        should "be high for portion < 100g and added_sugar > 12.5 / 100g" do
          assert_equal :high, Factory.build(:product, :portion => 99, :sugar => 13, :added_sugar => 13).fsa[:sugar]
        end
        
        should "be medium for portion < 100g and added_sugar < 12.5 / 100g" do
          assert_equal :medium, Factory.build(:product, :portion => 99, :sugar => 10, :added_sugar => 10).fsa[:sugar]
        end
        
      end
      
      context "with examples" do
        setup do
          @examples = [
            # Product 1 - Ready meal
            { :nutrition => { :fat => 2.2, :saturate => 0.4, :sugar => 1.5, :salt => 0.35, :portion => 400 }, 
              :banding   => { :fat => :low, :saturate => :low, :sugar => :low, :salt => :medium } },
            # Product 2 - Ready meal
            { :nutrition => { :fat => 6, :saturate => 0.4, :sugar => 1.5, :salt => 0.35, :portion => 400 }, 
              :banding   => { :fat => :high, :saturate => :low, :sugar => :low, :salt => :medium } },
            # Product 3 - Sandwich
            { :nutrition => { :fat => 8.4, :saturate => 1.8, :sugar => 2.9, :salt => 0.5, :portion => 180 }, 
              :banding   => { :fat => :medium, :saturate => :medium, :sugar => :low, :salt => :medium } },
            # Product 4 - Breakfast cereal (e.g. wheat biscuits)
            { :nutrition => { :fat => 2.5, :saturate => 0.5, :sugar => 0.9, :salt => 0.02, :portion => 45 }, 
              :banding   => { :fat => :low, :saturate => :low, :sugar => :low, :salt => :low } },
            # Product 5 - Breakfast cereal (e.g. high fruit muesli)
            { :nutrition => { :fat => 3.0, :saturate => 0.7, :sugar => 29.4, :added_sugar => 0, :salt => 0.04, :portion => 50 }, 
              :banding   => { :fat => :low, :saturate => :low, :sugar => :medium, :salt => :low } },
            # Product 6 - Breakfast cereal (e.g. flakes, nuts and fruit)
            { :nutrition => { :fat => 4.6, :saturate => 0.6, :sugar => 25.9, :added_sugar => 14.5, :salt => 0.64, :portion => 40 }, 
              :banding   => { :fat => :medium, :saturate => :low, :sugar => :high, :salt => :medium } }
          ]
        end
        
        should "return correct fat traffic light" do
          @examples.each do |e|
            p = Product.new(e[:nutrition])
            assert_equal e[:banding][:fat], p.fsa[:fat], "Was expecting #{e[:banding][:fat]} but got #{p.fsa[:fat]} for #{e[:nutrition].inspect}"
          end
        end

        should "return correct saturates traffic light" do
          @examples.each do |e|
            p = Product.new(e[:nutrition])
            assert_equal e[:banding][:saturate], p.fsa[:saturate], "Was expecting #{e[:banding][:saturate]} but got #{p.fsa[:saturate]} for #{e[:nutrition].inspect}"
          end
        end

        should "return correct sugars traffic light" do
          @examples.each do |e|
            p = Product.new(e[:nutrition])
            assert_equal e[:banding][:sugar], p.fsa[:sugar], "Was expecting #{e[:banding][:sugar]} but got #{p.fsa[:sugar]} for #{e[:nutrition].inspect}"
          end
        end

        should "return correct salt traffic light" do
          @examples.each do |e|
            p = Product.new(e[:nutrition])
            assert_equal e[:banding][:salt], p.fsa[:salt], "Was expecting #{e[:banding][:salt]} but got #{p.fsa[:salt]} for #{e[:nutrition].inspect}"
          end
        end
      end
    end
  end

end
