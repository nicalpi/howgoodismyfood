# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
   def w3c_date(date)
    date.utc.strftime("%Y-%m-%dT%H:%M:%S+00:00")
   end
end
