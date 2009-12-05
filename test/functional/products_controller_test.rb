require 'test_helper'

class ProductsControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  context "GET :index" do
    context "search for" do
      context "existing product" do
      
        setup do
          @product = Factory(:product)
          get :index,:q => @product.barcode
        end

        should_respond_with :success

        should_render_template :show

        should_assign_to(:product){@product}
      
      end

      context "an unexisting product" do
      
        setup do 
          get :index, :q => "this barcode doesn't exist"
        end

        should_respond_with :success

        should_render_template :new

        should "assign Product.new to production"  do
          assert assigns(:product).id.blank?
        end
      
      end
    end
  end

  context "GET :new" do
  
    setup do
      get :new
    end

    should_respond_with :success

    should "display the new product form" do
      assert_select "form#new_product",1
    end

    ["barcode","name","sugar","added_sugar","fat","saturate","sodium"].each do |key|
      should "diplay mandatory #{key} input" do
        assert_select "input[type='text']#product_#{key}",1
      end
    end

    should "preslect the radio button food" do
      assert "#product_kind_food[checked='checked']"
    end

    should "display the submit button" do
      assert_select "form#new_product button",1
    end
  
  
  end

  context "POST :create" do
    context "Valid product" do
    
      setup do
        post :create,:product => {:barcode => "1234567890",:name => "test product",:sodium => 2,:sugar => 2,:fat => 2,:saturate => 2,:sodium => 2,:kind => "food",:portion => 1}
      end
      should "create a valid product" do
        assert assigns(:product).valid?
      end
      should_redirect_to('the product page'){product_path(assigns(:product))}
    
    end

    context "an invalid product" do
      setup do
        post :create, :product => {:barcode => "12345678955"}
      end

      should_not_change "Product.count"

      should_render_template :new

      should "display error class" do
        assert_select ".fieldWithErrors"
      end

      should "set the flash error" do
        assert !flash[:error].blank?
      end

      should "display the flash error on the page" do
        assert_match flash[:error],@response.body
      end

    end
  end

  context "GET :show" do
    
    setup do
      @product = Factory(:product)
      get :show, :id => @product.id
      
    end
    
    should_respond_with :success

    should "display the product name" do
      assert_match @product.name,@response.body
    end

    should "list the 5 fsa element" do
      assert_select "#fsa_results li",4
    end

    ["Fat","Sugars","Saturates","Salt"].each do |str|
      should "display the banding #{str}" do
        assert_match "#{str}",@response.body
      end
    end

    [:fat,:sugar,:saturate,:sodium].each do |key|
      should "display the per serving portion of #{key}" do
        assert_match "#{@product.per_portion[key]}",@response.body
      end
    end

    #TODO test for matching class/fsa_result 


  end
end
