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
      
      should "be valid if =< than total sugar" do
        @product = Factory.build :product, :sugar => 6, :added_sugar => 6
        assert @product.valid?
      end
    end
  end
  
  context "FSA Traffic light signpost labelling for" do
    context "drink" do
    
    end
    
    context "food" do
      context "testing sugar" do
        should "be green for < 5 sugar" do
          assert_equal :green, Factory.build(:product, :sugar => 4).fsa[:sugar]
        end
        
        should "be red for portion > 100g and added_sugar > 15g / portion" do
          assert_equal :red, Factory.build(:product, :portion => 101, :sugar => 16, :added_sugar => 16).fsa[:sugar]
        end
        
        should "be red for portion > 100g and added_sugar < 15g / portion but added_sugar > 12.5 / 100g" do
          assert_equal :red, Factory.build(:product, :portion => 101, :sugar => 14, :added_sugar => 14).fsa[:sugar]
        end
        
        should "be amber for portion > 100g and added_sugar < 15g / portion and added_sugar < 12.5 / 100g" do
          assert_equal :amber, Factory.build(:product, :portion => 101, :sugar => 12, :added_sugar => 12).fsa[:sugar]
        end
        
        should "be red for portion < 100g and added_sugar > 12.5 / 100g" do
          assert_equal :red, Factory.build(:product, :portion => 99, :sugar => 13, :added_sugar => 13).fsa[:sugar]
        end
        
        should "be amber for portion < 100g and added_sugar < 12.5 / 100g" do
          assert_equal :amber, Factory.build(:product, :portion => 99, :sugar => 10, :added_sugar => 10).fsa[:sugar]
        end
        
      end
      
      context "with examples" do
        setup do
          @examples = [
            # Product 1 - Ready meal
            { :nutrition => { :fat => 2.2, :saturate => 0.4, :sugar => 1.5, :sodium => 0.35, :portion => 400 }, 
              :banding   => { :fat => :green, :saturate => :green, :sugar => :green, :sodium => :amber } },
            # Product 2 - Ready meal
            { :nutrition => { :fat => 6, :saturate => 0.4, :sugar => 1.5, :sodium => 0.35, :portion => 400 }, 
              :banding   => { :fat => :red, :saturate => :green, :sugar => :green, :sodium => :amber } },
            # Product 3 - Sandwich
            { :nutrition => { :fat => 8.4, :saturate => 1.8, :sugar => 2.9, :sodium => 0.5, :portion => 180 }, 
              :banding   => { :fat => :amber, :saturate => :amber, :sugar => :green, :sodium => :amber } },
            # Product 4 - Breakfast cereal (e.g. wheat biscuits)
            { :nutrition => { :fat => 2.5, :saturate => 0.5, :sugar => 0.9, :sodium => 0.02, :portion => 45 }, 
              :banding   => { :fat => :green, :saturate => :green, :sugar => :green, :sodium => :green } },
            # Product 5 - Breakfast cereal (e.g. high fruit muesli)
            { :nutrition => { :fat => 3.0, :saturate => 0.7, :sugar => 29.4, :added_sugar => 0, :sodium => 0.04, :portion => 50 }, 
              :banding   => { :fat => :green, :saturate => :green, :sugar => :amber, :sodium => :green } },
            # Product 6 - Breakfast cereal (e.g. flakes, nuts and fruit)
            { :nutrition => { :fat => 4.6, :saturate => 0.6, :sugar => 25.9, :added_sugar => 14.5, :sodium => 0.64, :portion => 40 }, 
              :banding   => { :fat => :amber, :saturate => :green, :sugar => :red, :sodium => :amber } }
          ]
        end
        
        should "return correct fat traffic light" do
          @examples.each do |e|
            p = Product.new(e[:nutrition])
            assert_equal e[:banding][:fat], p.fsa[:fat]
          end
        end

        should "return correct saturates traffic light" do
          @examples.each do |e|
            p = Product.new(e[:nutrition])
            assert_equal e[:banding][:saturate], p.fsa[:saturate]
          end
        end

        should "return correct sugars traffic light" do
          @examples.each do |e|
            p = Product.new(e[:nutrition])
            assert_equal e[:banding][:sugar], p.fsa[:sugar]
          end
        end

        should "return correct sodium traffic light" do
          @examples.each do |e|
            p = Product.new(e[:nutrition])
            assert_equal e[:banding][:sodium], p.fsa[:sodium]
          end
        end
      end
    end
  end

end
