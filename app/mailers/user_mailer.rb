class UserMailer < ApplicationMailer
  default from: email_address_with_name('info@ricschwartz.com', 'Herb and Du')

  def cat_email
    @results = params[:results]
    @user = @results.first[:user]

    @results.each_with_index do |result, index|
      if result[:base64_image_data]
        # Generate a unique filename for each inline attachment
        filename = "image_#{index}.png" # Assuming PNG, adjust if type is different or known
        attachments.inline[filename] = {
          mime_type: 'image/png', # Assuming PNG, adjust as necessary
          content: Base64.decode64(result[:base64_image_data])
        }
        result[:inline_attachment_filename] = filename # Store for template use
      end
    end

    mail(to: [@user.email], subject: 'Your AI Images Have Arrived')
  end

  def first_email
    @user = params[:user]
    @prompt = params[:prompt]

    mail(to: @user.email, subject: 'Image is processing...')
  end
end
