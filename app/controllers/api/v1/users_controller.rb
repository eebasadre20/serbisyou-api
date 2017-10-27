class Api::V1::UsersController < ApplicationController
  before_action :parse_image, only: :upload_avatar

  def create
    user = User.new( user_params )

    if user.save
      application = if Rails.env.test? 
                      Doorkeeper::Application.where( 
                        uid: params[:client_id], 
                        secret: params[:client_secret] 
                      ).first
                    else
                      Doorkeeper::Application.where( 
                        uid: Rails.application.secrets.doorkeeper['client_id'], 
                        secret: Rails.application.secrets.doorkeeper['client_secret']
                      ).first 
                    end

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
    render json: current_user, status: :ok 
  end

  def update
    user = User.find_by( params[:id] )

    if user.update( account_params )
      render json: { }, status: :ok
    else
      render json: user.errors.full_messages, status: :unproccessable_entity
    end
  end

  def upload_avatar
    render json: { error_message: 'Missing image base64' } and return if params[:image_base64].empty?
    
    avatar = Upload.new( uploadable: current_user, file: params[:parsed_image] )

    if avatar.save
      render json: avatar, status: :created
    else
      render json: avatar.errors, status: :unproccessable_entity
    end
  end

  private

  def user_params
    params.permit( :email, :password, :image_base64, roles_attributes: [:name]  )
  end

  def account_params
    params.permit( :email )
  end

  def parse_image
    image = Paperclip.io_adapters.for(params[:image_base64]) 
    image.original_filename = "file.jpg" 
    params[:parsed_image] = image
  end
end
