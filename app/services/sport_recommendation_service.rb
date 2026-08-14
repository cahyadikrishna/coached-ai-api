class SportRecommendationService
  include DeepseekClient

  def initialize(age:, gender:, daily_activity:, latest_fitness:)
    @age = age
    @gender = gender
    @daily_activity = daily_activity
    @latest_fitness = latest_fitness
  end

  def recommend
    chat(messages: [
      { role: "system", content: system_prompt },
      { role: "user", content: user_prompt }
    ])
  end

  private

  def system_prompt
    "You are a friendly, knowledgeable sports and fitness advisor. " \
    "You recommend the most suitable sport or physical activity for a person " \
    "based on their age, gender, daily activity level, and recent fitness history. " \
    "Respond in plain text with 2-3 clear, practical recommendations."
  end

  def user_prompt
    <<~TEXT.strip
      Age: #{@age}
      Gender: #{@gender}
      Daily activity: #{@daily_activity}
      Latest fitness: #{@latest_fitness}

      Based on the above, recommend the most suitable sports and briefly explain why.
    TEXT
  end
end
