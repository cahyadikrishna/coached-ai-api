class SessionsController < ApplicationController
  STRAVA_AUTHORIZE_URL = "https://www.strava.com/oauth/authorize".freeze
  STRAVA_TOKEN_URL     = "https://www.strava.com/oauth/token".freeze

  def connect
    url = "#{STRAVA_AUTHORIZE_URL}?#{{
      client_id: ENV.fetch("STRAVA_CLIENT_ID"),
      redirect_uri: ENV.fetch("STRAVA_REDIRECT_URI"),
      response_type: "code",
      approval_prompt: "auto",
      scope: "read,activity:read_all"
    }.to_query}"
    redirect_to url, allow_other_host: true
  end

  def strava_callback
    data = exchange_code_for_token(params[:code])
    athlete = data["athlete"]

    user = User.find_or_initialize_by(strava_id: athlete["id"].to_s)
    user.update!(
      access_token: data["access_token"],
      refresh_token: data["refresh_token"],
      token_expires_at: data["expires_at"]
    )

    render json: { strava_id: user.strava_id }, status: :ok
  end

  private

  def exchange_code_for_token(code)
    response = Faraday.post(STRAVA_TOKEN_URL) do |req|
      req.params.merge!(
        client_id: ENV.fetch("STRAVA_CLIENT_ID"),
        client_secret: ENV.fetch("STRAVA_CLIENT_SECRET"),
        code: code,
        grant_type: "authorization_code"
      )
    end
    JSON.parse(response.body)
  end
end
