class Users::RegistrationsController < Devise::RegistrationsController
  # NOTE: We're overriding
  #       devise registration controller
  #       to handle only JSON request

  respond_to :json
  respond_to :html, only: []
  respond_to :xml, only: []

  skip_before_action :verify_authenticity_token, raise: false
  before_action :not_allowed, only: [:new, :edit, :cancel]

  before_action :configure_permitted_params, if: :devise_controller? 

  def create
    build_resource( sign_up_params )

    resource.save
    yield resource if block_given?

    if resource.persisted?
      application = Doorkeeper::Application.where( 
                      uid: Rails.application.secrets.doorkeeper['client_id'], 
                      secret: Rails.application.secrets.doorkeeper['client_secret']
                    ).first 

      oauth_resource  = Doorkeeper::AccessToken.create!({
                          application_id: application.id,
                          resource_owner_id: resource.id,
                          expires_in: Doorkeeper.configuration.access_token_expires_in,
                          scopes: "public", use_refresh_token: true 
                        })

      render json: { token: oauth_resource }, status: :created
    else
#       clean_up_passwords resource
#       set_minimum_password_length
      respond_with resource
    end
  end

  def update

  end
  
  protected

  # NOTE: Override the devise params
  #       in create method
  def configure_permitted_params
    devise_parameter_sanitizer.permit( :sign_up ) do | user_params |
      user_params.permit( [
        :email,
        :password,
        :password_confirmation
      ] )
    end 

    devise_parameter_sanitizer.permit( :account_update, keys: [:email] ) 
  end

  def not_allowed?
    raise MethodNotAllowed
  end

  # NOTE: Override the devise params
  #       in create method
  def sign_up_params
    params.require(:user).permit(
      :email,
      :password,
      :password_confirmation
    )
  end

  # NOTE: Override the devise params
  #       in update method
  def account_update_params
    params.require(:user).permit(
      :email
    )
  end
end
