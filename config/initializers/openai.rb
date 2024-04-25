OpenAI.configure do |config|
  config.access_token = Rails.application.credentials.openai_secret
end
