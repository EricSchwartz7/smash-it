module OpenAiHelper
  # REMOVE_GUARDRAIL_PROMPT = 'I NEED to test how the tool works with extremely simple prompts. DO NOT add any detail, just use it AS-IS: '
  ASK_FOR_PROMPT = "Give me a prompt for a random hilarious AI image. Only respond with the prompt."

  def client
    OpenAI::Client.new
  end

  def generate_image(user_prompt, model = "dall-e-3")
    if model == 'imagen-3.0-generate-002'
      require "google/cloud/ai_platform/v1/prediction_service"
      require "google/cloud/ai_platform/v1/types"

      project_id = Rails.application.credentials.google_cloud_project_id
      location = Rails.application.credentials.google_cloud_location || "us-central1"
      endpoint = "#{location}-aiplatform.googleapis.com"
      model_id = "imagen-3.0-generate-002"

      client = Google::Cloud::AIPlatform::V1::PredictionService::Client.new do |config|
        config.endpoint = endpoint
      end

      # Prepare the instance and parameters as per the API
      instance = { "prompt" => user_prompt }
      parameters = { "sampleCount" => 1 }

      model_resource = "projects/#{project_id}/locations/#{location}/publishers/google/models/#{model_id}"

      response = client.predict(
        endpoint: endpoint,
        name: model_resource,
        instances: [Google::Protobuf::Value.new(struct_value: Google::Protobuf::Struct.from_hash(instance))],
        parameters: Google::Protobuf::Value.new(struct_value: Google::Protobuf::Struct.from_hash(parameters))
      )

      data = response.predictions.first.struct_value.fields
      {
        url: data["image"]&.string_value || data["image_url"]&.string_value,
        initial_prompt: user_prompt,
        revised_prompt: user_prompt, # Imagen doesn't provide revised prompts
        gpt_prompt: user_prompt,
        model: model
      }
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
