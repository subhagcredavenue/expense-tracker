class UsersController < ApplicationController
  before_action :set_user, only: %i[show showusertransactions update destroy]

  # GET /users
  def index
    email = params[:email]
    password = params[:password]

    @user = User.where(email: email).first
    if @user
      if @user.password == password
        render json: { userExist: true, message: "Authorized", user: @user.as_json(only: [:_id, :name, :email]) },
               status: 202
      else
        render json: { userExist: false, message: "Password incorrect" }, status: 401
      end
    else
      render json: { userExist: false, message: "User or password incorrect" }, status: 401
    end
  end

  # GET /users/1
  def show
    render json: User.find(params[:id]), include: [:transactions]
  end

  def showusertransactions
    uid = params[:id]
    @user = @user.desc(:date)
    if uid
      @transactions = @user.where(user_id: BSON::ObjectId(uid))
    end
  end

  # POST /users
  def create
    @user = User.new(user_params)
    #    email=params[:email]
    # puts :email
    # @users=User.all
    # if user.where(email: email)

    # end
    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:name, :email, :password, :DOB)
  end
end
