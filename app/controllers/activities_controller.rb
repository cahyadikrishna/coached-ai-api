class ActivitiesController < ApplicationController
  before_action :require_user!

  def index
    render json: StravaService.new(current_user).activities(since: 7.days.ago)
  end

  def show
    render json: StravaService.new(current_user).activity(params[:id])
  end
end
