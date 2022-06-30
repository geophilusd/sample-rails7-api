# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :check_admin, only: [:create]

  def create
    @user = User.new(user_params)
    @user.role = 'user'
    if @user.save
      head :created
    else
      render json: { errors: @user.errors }, status: :unprocessible_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
