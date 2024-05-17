module OpenAiHelper
  # REMOVE_GUARDRAIL_PROMPT = 'I NEED to test how the tool works with extremely simple prompts. DO NOT add any detail, just use it AS-IS: '
  ASK_FOR_PROMPT = "Give me a prompt for a random hilarious AI image. Only respond with the prompt."

  def client
    OpenAI::Client.new
  end

  def generate_image(prompt = nil)
    prompt ||= ask_for_prompt
    params = {
      model: "dall-e-3",
      prompt: prompt,
      size: "1024x1024",
      quality: "standard"
    }
    response = client.images.generate(parameters: params)
    puts "\n #{response}"
    data = response.dig("data").first
    {
      url: data['url'],
      revised_prompt: data['revised_prompt'],
      gpt_prompt: prompt
    }
  end

  def ask_for_prompt
    params = {
      model: "gpt-4-turbo",
      messages: [{ role: "user", content: ASK_FOR_PROMPT}],
      temperature: 1.3
    }
    puts "\n asking for prompt..."
    response = client.chat(parameters: params)
    content = response.dig("choices", 0, "message", "content")
    puts "\n #{content}"
    content
  end
end
