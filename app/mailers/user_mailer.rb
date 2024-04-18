class UserMailer < ApplicationMailer
  default from: 'info@ricschwartz.com'

  def welcome_email
    @user = params[:user]
    @url  = 'https://ricschwartz.com/users/sign_in'
    mail(to: @user.email, subject: 'Welcome to My Awesome Site')
  end
end
