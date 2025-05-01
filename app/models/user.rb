class User < ApplicationRecord
  extend OpenAiHelper

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :lists

  def user_prompt
    self.lists.last.tasks.first.description
  end

  def ai_image_email(models)
    results = []
    models.each do |model|
      res = User.generate_image(user_prompt, model)
      puts "\n generated image res for #{model}: #{res} \n"
      results << {
        user: self,
        initial_prompt: res[:initial_prompt],
        prompt: res[:gpt_prompt],
        image_url: res[:url],
        revised_prompt: res[:revised_prompt],
        model: res[:model]
      }
    end

    # Send email with all results
    email_res = UserMailer.with(results: results).cat_email.deliver_now
    puts "\n email sent. \n"
    results
  end

  def first_email
    params = {
      user: self,
      prompt: prompt
    }
    UserMailer.with(params).first_email.deliver_now
  end
end
