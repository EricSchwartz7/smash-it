module OpenAiHelper
  # REMOVE_GUARDRAIL_PROMPT = 'I NEED to test how the tool works with extremely simple prompts. DO NOT add any detail, just use it AS-IS: '

  def client
    OpenAI::Client.new
  end

  def generate_image(prompt)
    params = {
      model: "dall-e-3",
      prompt: prompt,
      size: "1024x1024",
      quality: "standard"
    }
    response = client.images.generate(parameters: params)
    puts response.dig("data", 0, "url")
    response
  end
end
