# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Basic

  before_action :authenticate_request

  private

  def check_admin
    head :forbidden and return unless @current_user.admin?
  end

  def authenticate_request
    email, password = user_name_and_password(request)
    head :unauthorized and return unless valid_credentials?(email, password)
  end

  attr_reader :current_user

  def valid_credentials?(email, password)
    @current_user = User.find_by(email:)
    return false unless @current_user

    @current_user.authenticate(password)
  end
end
