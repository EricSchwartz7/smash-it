require "net/http"
require "json"
require "uri"

module OpenAiHelper
  # REMOVE_GUARDRAIL_PROMPT = 'I NEED to test how the tool works with extremely simple prompts. DO NOT add any detail, just use it AS-IS: '
  ASK_FOR_PROMPT = "Give me a prompt for a random hilarious AI image. Only respond with the prompt."

  def client
    OpenAI::Client.new
  end

  def generate_image_with_google_cloud(user_prompt = "a futuristic city skyline at sunset, in the style of cyberpunk", model = "imagen-3.0-generate-002")
    project_id = Rails.application.credentials.google_cloud_project_id
    location = Rails.application.credentials.google_cloud_location || "us-central1"
    endpoint = "#{location}-aiplatform.googleapis.com"

    uri = URI("https://#{endpoint}/v1/projects/#{project_id}/locations/#{location}/publishers/google/models/#{model}:predict")

    # prompt = "a futuristic city skyline at sunset, in the style of cyberpunk"
    request_body = {
      instances: [
        {
          prompt: user_prompt
        }
      ]
    }.to_json

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    access_token = `gcloud auth print-access-token`.strip
    req = Net::HTTP::Post.new(uri.path, {
      "Authorization" => "Bearer #{access_token}",
      "Content-Type" => "application/json"
    })
    req.body = request_body

    response = http.request(req)
    response_body = JSON.parse(response.body)
    # puts JSON.pretty_generate(JSON.parse(response.body))
    #
    File.open("output.jpg", "wb") do |f|
      f.write(Base64.decode64(response_body["predictions"].first["bytesBase64Encoded"]))
    end

    # {
    #   url: data["image"]&.string_value || data["image_url"]&.string_value,
    #   initial_prompt: user_prompt,
    #   revised_prompt: user_prompt, # Imagen doesn't provide revised prompts
    #   gpt_prompt: user_prompt,
    #   model: model
    # }
  end

  def generate_image(user_prompt, model = "dall-e-3")
    if model == 'imagen-3.0-generate-002'
      generate_image_with_google_cloud(user_prompt, model)
    else
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
