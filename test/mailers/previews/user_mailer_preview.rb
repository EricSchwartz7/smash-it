# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def cat_email
    UserMailer.with(user: User.first).cat_email
  end
end
