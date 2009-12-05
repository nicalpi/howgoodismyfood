require 'test_helper'

class FrontControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  
  context "GET :homepage" do
  
    setup do
      get :homepage
    end

    should_respond_with :success

    should "have a form" do
      assert_select "form",1
    end

    should "have a q input" do
      assert_select "form #q",1
    end

    should "send data do products_path" do
      assert_select "form[action=?]",products_path
    end

    should "be able to submit the form" do
      assert_select "form button",1
    end
    
    should "see link to about page" do
      assert_select "a[href=?]", url_for(:controller => "front",:action => "about",:only_path => true)
    end
 
    should "see link to api page" do
      assert_select "a[href=?]", url_for(:controller => "front",:action => "api",:only_path => true)
    end
  
  end

  context "GET :about" do
    setup do
      get :about
    end

    should_respond_with :success
  end

  context "GET :api" do
    setup do
      get :api
    end

    should_respond_with :success
  end
 
  
end
