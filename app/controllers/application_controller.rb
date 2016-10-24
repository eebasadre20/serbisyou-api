class ApplicationController < ActionController::API
  before_action :doorkeeper_authorize!, unless: :allowed?

  private

  def allowed?
    whitelisted? && client_authorized?
  end

  def whitelisted?
    endpoints_whitelists = [ 
        { controller: 'users', actions: [ 'create' ] }
      ]

    endpoints_whitelists.any? { | e | e[:controller] == controller_name && e[:actions].include?( action_name ) }
  end

  def client_authorized?
    Doorkeeper::Application.where( uid: request.headers['HTTP_CLIENT_ID'], secret: request.headers['HTTP_CLIENT_SECRET'] ).first.present?
  end

  def current_resource_owner
    User.find( params[:id] ) #if doorkeeper_token
  end
end
