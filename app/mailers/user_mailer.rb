class UserMailer < ApplicationMailer
  default from: email_address_with_name('info@ricschwartz.com', 'Herb and Du')

  def cat_email
    @user = params[:user]
    @prompt = params[:prompt]
    @revised_prompt = params[:revised_prompt]
    @image_url = params[:image_url]

    mail(to: @user.email, subject: 'AI Image of the Day')
  end
end
