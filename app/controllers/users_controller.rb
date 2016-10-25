class UsersController < ApplicationController
  def create
    user = User.new( user_params )

    if user.save
      application = Doorkeeper::Application.where( 
                        uid: Rails.application.secrets.doorkeeper['client_id'], 
                        secret: Rails.application.secrets.doorkeeper['client_secret']
                      ).first 

      oauth_resource  = Doorkeeper::AccessToken.create!({
                          application_id: application.id,
                          resource_owner_id: user.id,
                          expires_in: Doorkeeper.configuration.access_token_expires_in,
                          scopes: "public", use_refresh_token: true 
                        })

      render json: { user_id: oauth_resource.id,
                     token: oauth_resource.token,
                     refresh_token: oauth_resource.refresh_token,
                     expires_in: oauth_resource.expires_in 
                    }, status: :created
    else
      render json: user.errors, status: :unproccessable_entity
    end
  end

  def show
    render json: { user: 'Edsil Basadre' }, status: :ok 
  end

  def update
    user = User.find_by( params[:id] )

    if user.update( account_params )
      render json: { }, status: :ok
    else
      render json: user.errors.full_messages, status: :unproccessable_entity
    end
  end

  private

  def user_params
    params.permit( :email, :password )
  end

  def account_params
    params.permit( :email )
  end
end
