class StravaService
  STRAVA_TOKEN_URL = "https://www.strava.com/oauth/token".freeze
  STRAVA_API_URL   = "https://www.strava.com/api/v3".freeze

  def initialize(user)
    @user = user
  end

  def activities(since:, per_page: 100)
    handle(connection.get("/athlete/activities", after: since.to_i, per_page: per_page))
  end

  def activity(id)
    handle(connection.get("/activities/#{id}"))
  end

  private

  def connection
    Faraday.new(url: STRAVA_API_URL) do |f|
      f.headers["Authorization"] = "Bearer #{access_token}"
      f.response :json
      f.adapter Faraday.default_adapter
    end
  end

  def access_token
    refresh_token! if token_expired?
    @user.access_token
  end

  def token_expired?
    @user.token_expires_at.nil? || Time.now.to_i >= @user.token_expires_at
  end

  def refresh_token!
    response = Faraday.post(STRAVA_TOKEN_URL) do |req|
      req.params.merge!(
        grant_type: "refresh_token",
        client_id: ENV.fetch("STRAVA_CLIENT_ID"),
        client_secret: ENV.fetch("STRAVA_CLIENT_SECRET"),
        refresh_token: @user.refresh_token
      )
    end
    raise "Strava token refresh failed: #{response.body}" unless response.success?

    data = JSON.parse(response.body)
    @user.update!(
      access_token: data["access_token"],
      refresh_token: data["refresh_token"],
      token_expires_at: data["expires_at"]
    )
  end

  def handle(response)
    raise "Strava API error #{response.status}: #{response.body}" unless response.success?
    response.body
  end
end
