class OtpMailer < ApplicationMailer
  default :from => Rails.application.credentials[Rails.env.to_sym][:EMAIL]

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



  def send_transaction_history(email, user_id)
    # @transactions=transactions.to_a
    @transactions = Transaction.where(user_id: BSON::ObjectId(user_id))

    message = mail(:to => email, :subject => "Transaction history")

  end

end
