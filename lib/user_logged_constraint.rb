class UserLoggedConstraint
  def initialize(logged)
    @logged = logged
  end

  def matches? request
    (request.session[:user_id].present? || request.cookies['remember_me_token'].present?) == @logged
  end
end
