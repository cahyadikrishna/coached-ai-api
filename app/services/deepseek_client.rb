module DeepseekClient
  DEFAULT_MODEL    = "deepseek-chat".freeze
  DEFAULT_URI_BASE = "https://api.deepseek.com".freeze

  def chat(messages:, model: nil, temperature: 0.7)
    response = client.chat(parameters: {
      model: model || ENV.fetch("DEEPSEEK_MODEL", DEFAULT_MODEL),
      messages: messages,
      temperature: temperature
    })

    response.dig("choices", 0, "message", "content")
  end

  private

  def client
    @client ||= OpenAI::Client.new(
      access_token: ENV.fetch("DEEPSEEK_API_KEY"),
      uri_base: DEFAULT_URI_BASE
    )
  end
end
