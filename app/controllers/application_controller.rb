class ApplicationController < ActionController::API
  before_action :doorkeeper_authorize!, unless: :allowed?

  private

  def allowed?
    whitelisted? && client_authorized?
  end

  def whitelisted?
    endpoints_whitelists = [ 
        { controller: 'users', actions: [ 'create', 'upload_avatar' ] }
      ]

    endpoints_whitelists.any? { | e | e[:controller] == controller_name && e[:actions].include?( action_name ) }
  end

  def client_authorized?
    Doorkeeper::Application.where( uid: request.headers['HTTP_CLIENT_ID'], secret: request.headers['HTTP_CLIENT_SECRET'] ).first.present?
  end

  def current_user
    @current_user ||= User.find( doorkeeper_token.resource_owner_id ) if doorkeeper_token
  end
end
