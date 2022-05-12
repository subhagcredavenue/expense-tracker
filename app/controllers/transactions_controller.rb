class TransactionsController < ApplicationController
  before_action :set_transaction, only: %i[ show update destroy ]
  NO_OF_DAYS=30


  # GET /transactions
  def index
    @transactions = Transaction.all
    duration = params[:duration]
    max=params[:max]
    user=params[:user]
    type=params[:transaction_type]
        category=params[:category_type]
  if user
    @transactions=@transactions.where(user_id:BSON::ObjectId(user))
  end

  if max
    # @transactions= @transactions.desc(:amount).limit(max)
 @transactions= Transaction.collection.aggregate([{"$project"=>{ category: -1, amount: 1} }, {'$group'=>{_id:{category:'$category'},amount:{'$sum':'$amount'}}}])

 @transactions=@transactions.to_a.sort_by { |h | -h[:amount] }
 @transactions=@transactions.slice(0,max.to_i)
#  627b3e305bac34001b4f6cda
   end

   if duration
    duration.to_i
    @transactions=@transactions.where({:date.gte => (Date.today-(NO_OF_DAYS*duration.to_i))}).order(date: :desc)
   end 

   if type
   @transactions=@transactions.where({type: type})

   end
   if category
        @transactions=@transactions.where({category: category}) #need to verify
   end
    
    render json: @transactions
  
  end

  # GET /transactions/1
  def show
    render json: @transaction
  end

  # POST /transactions
  def create
    @transaction = Transaction.new(transaction_params)
      #@transaction.
    if @transaction.save
      render json: @transaction, status: :created, location: @transaction
    else
      render json: @transaction.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /transactions/1
  def update
    if @transaction.update(transaction_params)
      render json: @transaction
    else
      render json: @transaction.errors, status: :unprocessable_entity
    end
  end

  # DELETE /transactions/1
  def destroy
  #  if 
  #
   # else 
    #end
 

@transaction.destroy 
render json: { "response": "Success"}
    rescue Exception
render json:"Failed"
    end

    


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transaction
      @transaction = Transaction.find(params[:id])

    end

 def record_not_found(error)
    render json: "404"
  end

    # Only allow a list of trusted parameters through.
    def transaction_params
      params.require(:transaction).permit(:title, :amount, :type,:category, :date, :user_id )
    end
end
