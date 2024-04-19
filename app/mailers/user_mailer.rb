class UserMailer < ApplicationMailer
  default from: email_address_with_name('info@ricschwartz.com', 'Herb and Du')

  def cat_email
    @user = params[:user]
    @url  = 'https://ricschwartz.com'
    mail(to: @user.email, subject: 'Snackiessss')
  end
end
