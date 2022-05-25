class OtpMailer < ApplicationMailer
  default :from => "subhagjain10@gmail.com"

  def caller
    message = OtpMailer.email_message()
    message.deliver_now
  end

  def email_message()
    mail(:to => "subhagjain@gmail.com", :subject => "hello", :body => "body")
  end

  def generate_otp(email)
    @otp = rand(100000...999999)
    message = mail(:to => email, :subject => "Your OTP: #{@otp}")
    message.deliver
  end
end
