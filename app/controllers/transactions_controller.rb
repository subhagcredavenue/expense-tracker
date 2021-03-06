class TransactionsController < ApplicationController
  before_action :set_transaction, only: %i[show update showusertransactions]
  NO_OF_DAYS = 30

  @transaction
  # GET /transactions
  def index
    @transactions = Transaction.all
    render json: @transactions
  end

  def history
    @transactions = Transaction.all
    uid = params[:user_id]
    @transactions = @transactions.where(user_id: BSON::ObjectId(uid))
    render json: @transactions
  end

  def show_user_transactions
    @transactions = Transaction.all
    uid = params[:user_id]
    limit = params[:limit]
    @transactions = @transactions.where(user_id: BSON::ObjectId(uid))
    duration = params[:duration]
    max = params[:max]
    type = params[:transaction_type]
    category = params[:category_type]
    @transactions = @transactions.desc(:date)

    if duration
      duration.to_i
      @transactions = @transactions.where({ :date.gte => (Date.today - (NO_OF_DAYS * duration.to_i)) }).order(date: :desc)
    end
    if type
      @transactions = @transactions.where({ type: type })

    end
    if category
      @transactions = @transactions.where({ category: category }) # need to verify
    end
    if limit
      @transactions = @transactions.to_a.slice(0, limit.to_i)
    end
    render json: @transactions
  end

  # GET /transactions/1
  def show
    @transaction = Transaction.all
    @transaction = @transaction.find_by(id: params[:id])

    render json: @transaction
  end

  # POST /transactions
  def create
    @transaction = Transaction.new(transaction_params)
    user_id = params[:user_id]
    @transaction.user_id = user_id
    @transaction.amount = @transaction.amount.to_i
    if @transaction.save
      # render json: @transaction, status: :created, location: @transaction
      render json: @transaction, status: :created
    else
      render json: @transaction.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /transactions/1
  def update
    @transaction = Transaction.all
    @transaction = @transaction.find_by(id: params[:id])
    if @transaction.update(transaction_params)
      render json: @transaction
    else
      render json: @transaction.errors, status: :unprocessable_entity
    end
  end

  # DELETE /transactions/1
  def destroy
    id = params[:id]
    if Transaction.find(id).destroy
      render json: { "response": "Successfully deleted" }
    else
      render json: "Tranaction not found with #{id}", status: 404
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_transaction
    @transactions = Transaction.all
    if !:user_id
      @transaction = Transaction.find(params[:id])
    end
  end

  def record_not_found(error)
    render json: "404"
  end

  # Only allow a list of trusted parameters through.
  def transaction_params
    params.require(:transaction).permit(:title, :amount, :type, :category, :date,)
  end
end
