module OpenAiHelper
  # REMOVE_GUARDRAIL_PROMPT = 'I NEED to test how the tool works with extremely simple prompts. DO NOT add any detail, just use it AS-IS: '
  ASK_FOR_PROMPT = "Give me a prompt for a random hilarious AI image. Only respond with the prompt."

  def client
    OpenAI::Client.new
  end

  def generate_image(user_prompt, model = "dall-e-3")
    # prompt = ask_for_prompt(user_prompt)
    prompt = user_prompt
    params = {
      model: model,
      prompt: prompt,
      size: "1024x1024",
      # quality: "standard"
    }
    puts "\n Generating image with prompt: #{prompt}, model: #{model}"
    response = client.images.generate(parameters: params)
    puts "\n #{response}"
    data = response.dig("data").first
    {
      url: data['url'],
      initial_prompt: user_prompt,
      revised_prompt: data['revised_prompt'],
      gpt_prompt: prompt,
      model: model
    }
  end

  def ask_for_prompt(user_prompt)
    params = {
      model: "gpt-4o",
      messages: [{ role: "user", content: user_prompt}],
      temperature: 1.3
    }
    puts "\n asking for prompt..."
    response = client.chat(parameters: params)
    content = response.dig("choices", 0, "message", "content")
    puts "\n #{content}"
    content
  end
end
