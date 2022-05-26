class OtpMailer < ApplicationMailer
  default :from => "subhagjain10@gmail.com"

  def caller
    message = OtpMailer.email_message()
    message.deliver_now
  end

  def email_message()
    mail(:to => "subhagjain@gmail.com", :subject => "hello", :body => "body")
  end

  def generate_otp(email,otp)
   @otp=otp
    message = mail(:to => email, :subject => "Your OTP")
    message.deliver
  end



  def send_transaction_history(email, transactions)
    @transactions=transactions
    message = mail(:to => email, :subject => "Transaction history")

  end

end
