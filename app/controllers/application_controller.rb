class ApplicationController < ActionController::API
  before_action :doorkeeper_authorize! 

  def current_resource_owner
    
    binding.pry
    User.find( params[:id] ) #if doorkeeper_token
  end
end
