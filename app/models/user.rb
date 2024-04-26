class User < ApplicationRecord
  extend OpenAiHelper

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :lists

  def prompt
    self.lists.last.tasks.first.description
  end

  def ai_image_email
    res = User.generate_image(prompt)
    puts res
    data = res['data'].last
    params = {
      user: self,
      prompt: prompt,
      image_url: data['url'],
      revised_prompt: data['revised_prompt']
    }
    UserMailer.with(params).cat_email.deliver_later
    params
  end
end
