class UsersController < ApplicationController
  def show
    render json: { user: current_resource_owner }, status: :ok 
  end
end
