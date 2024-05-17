class User < ApplicationRecord
  extend OpenAiHelper

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :lists

  def stored_prompt
    self.lists.last.tasks.first.description
  end

  def ai_image_email
    # first_email
    res = User.generate_image
    puts "\n generated image res: #{res} \n"
    # data = res['data'].last
    params = {
      user: self,
      initial_prompt: OpenAiHelper::ASK_FOR_PROMPT,
      prompt: res[:gpt_prompt],
      image_url: res[:url],
      revised_prompt: res[:revised_prompt]
    }
    email_res = UserMailer.with(params).cat_email.deliver_now
    # puts email_res.inspect
    puts "\n email sent. \n"
    params
  end

  def first_email
    params = {
      user: self,
      prompt: prompt
    }
    UserMailer.with(params).first_email.deliver_now
  end
end
