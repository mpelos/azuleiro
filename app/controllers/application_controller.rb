# encoding: UTF-8

class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :require_login

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => "Ha. Você não pensou que esse sitema fosse seguro, não é mesmo?"
  end

  private

  def not_authenticated
    redirect_to login_path, :alert => "Faça o login para acessar a página."
  end
end
