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

end
