class FrontController < ApplicationController
  def homepage
   set_metadata(:page_title => "search for a product",:body_id => "homepage") 
  end

  def api
    set_metadata(:page_title => "API?",:description => "How to request an howgoodismyfood api?",:body_id => "api")
  end

  def about
    set_metadata(:page_title => "About",:desciption => "Lean more about howgoodismyfood",:body_id => "about")
  end
end
