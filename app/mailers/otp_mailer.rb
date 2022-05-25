class OtpMailer < ApplicationMailer
  default :from => ENV["EMAIL"]

  def generate_otp(email)
    @otp = rand(100000...999999)
    mail(:to=> email, :subject=> "Your OTP: #{@otp}")
  end
end
