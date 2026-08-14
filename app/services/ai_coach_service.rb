class AiCoachService
  include DeepseekClient

  def initialize(user)
    @user = user
  end

  def generate!
    activities = StravaService.new(@user).activities(since: 7.days.ago)
    metrics = aggregate(activities)
    content = generate_summary(metrics)

    @user.weekly_summaries.create!(
      start_date: 7.days.ago.to_date,
      end_date: Date.current,
      metrics: metrics,
      content: content
    )
  end

  private

  def aggregate(activities)
    {
      total_distance: activities.sum { |a| a["distance"].to_f },     # meters
      total_moving_time: activities.sum { |a| a["moving_time"].to_i }, # seconds
      activity_count: activities.size,
      activity_types: activities.map { |a| a["type"] }.compact.uniq
    }
  end

  def generate_summary(metrics)
    chat(messages: [
      { role: "system", content: system_prompt },
      { role: "user", content: user_prompt(metrics) }
    ])
  end

  def system_prompt
    "You are an elite endurance coach with decades of experience. " \
    "You analyze an athlete's training data and deliver clear, motivating, " \
    "and actionable coaching feedback."
  end

  def user_prompt(metrics)
    <<~TEXT.strip
      Here are the athlete's last 7 days of training:
      - Total distance: #{metrics[:total_distance]} meters
      - Total moving time: #{metrics[:total_moving_time]} seconds
      - Number of activities: #{metrics[:activity_count]}
      - Activity types: #{metrics[:activity_types].join(", ")}

      Provide a 3-sentence summary of their week, followed by 1 piece of
      targeted recovery advice.
    TEXT
  end
end
