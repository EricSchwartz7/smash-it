class UserMailer < ApplicationMailer
  default from: 'info@ricschwartz.com'

  def cat_email
    @user = params[:user]
    @url  = 'https://ricschwartz.com'
    mail(to: @user.email, subject: 'Herb and Du')
  end
end
