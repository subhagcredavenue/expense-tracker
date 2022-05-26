class CustomController < ApplicationController
  before_action :set_transaction

  def show_user_transactions
    @transactions = @transactions.desc(:date)
    render json: @transactions
  end
  def send_otp
    @otp = rand(100000...999999)

    OtpMailer.generate_otp(@user.email,@otp).deliver_later

  end
  def send_transaction_history
      # OtpMailer.send_transaction_history(@user.email, @transactions).deliver_later
      OtpMailer.send_transaction_history(@user.email, params[:user_id]).deliver_later
  end

  def max_debit
    if params[:max]
      max = params[:max]
    else 
      max =1
    end
    @transactions = Transaction.collection.aggregate([{ '$match' => { user_id: @user_id, type: "DEBIT" } },
                                                      { '$group' => { _id: { category: '$category', type: '$type' }, amount: { '$sum': '$amount' } } }, { "$sort": { "amount": -1 } }])
    @transactions = @transactions.to_a.sort_by { |h| -h[:amount] }
    @transactions = @transactions.slice(0, max.to_i)
    
    
#    OtpMailer.deliver_now
    # puts ENV['EMAIL']
    render json: @transactions
  end

  def graph_data
    @transactions = Transaction.collection.aggregate([{ '$match' => { user_id: @user_id } },
                                                      { '$group' => { _id: { type: '$type', date: '$date' },
                                                                      amount: { '$sum': '$amount', } } },
                                                      { '$sort': { '_id.date': 1 } }])
    render json: @transactions
  end

  private

  def set_transaction
    @transactions = Transaction.all
    @user_id = BSON::ObjectId(params[:user_id])
    @user= User.find_by(_id: @user_id)
    @transactions = @transactions.where(user_id: BSON::ObjectId(params[:user_id]))

    if params[:id]
      @transaction = Transaction.find_by(params[:id])
    end
  end
end
