# Load the rails application
require File.expand_path('../application', __FILE__)

module Spira
  def settings
    @settings||={}
  end
  module_function :settings
end
# Initialize the rails application
DrugSite::Application.initialize!