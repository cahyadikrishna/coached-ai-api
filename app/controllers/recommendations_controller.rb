class RecommendationsController < ApplicationController
  def create
    recommendation = SportRecommendationService.new(recommendation_params).recommend
    render json: { recommendation: recommendation }
  end

  private

  def recommendation_params
    params.permit(:age, :gender, :daily_activity, :latest_fitness)
  end
end
