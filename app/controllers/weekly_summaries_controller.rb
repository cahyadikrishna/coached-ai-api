class WeeklySummariesController < ApplicationController
  before_action :require_user!

  def index
    render json: current_user.weekly_summaries.order(start_date: :desc)
  end

  def create
    render json: AiCoachService.new(current_user).generate!, status: :created
  end
end
