# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  before_filter :set_metadata
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  protected

  def set_metadata(options ={})
    @page_title = "Serialcooking | " + options[:page_title] ||= ""
    @description = options[:description] ||= "Serialcooking, bring the web into your kitchen"
    @tags = options[:tags] ||= "cooking,food,recipe,blogs"
    @body_id = options[:body_id] ||= ""
   end

end
