class ApplicationController < ActionController::API
  def current_user
    @current_user ||= User.find_by(strava_id: bearer_token)
  end

  def require_user!
    head :unauthorized unless current_user
  end

  private

  def bearer_token
    header = request.headers["Authorization"].to_s
    header.delete_prefix("Bearer ").strip if header.start_with?("Bearer ")
  end
end
