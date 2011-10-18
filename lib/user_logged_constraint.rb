class UserLoggedConstraint
  def initialize(logged)
    @logged = logged
  end

  def matches? request
    request.session[:user_id].present? == @logged
  end
end
