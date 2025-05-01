class UserMailer < ApplicationMailer
  default from: email_address_with_name('info@ricschwartz.com', 'Herb and Du')

  def cat_email
    @results = params[:results]
    @user = @results.first[:user]

    mail(to: [@user.email], subject: 'Your AI Images Have Arrived')
  end

  def first_email
    @user = params[:user]
    @prompt = params[:prompt]

    mail(to: @user.email, subject: 'Image is processing...')
  end
end
