class PrototypesController < ApplicationController
  before_action :authenticate_user!, only: [:new]
  before_action :move_to_index, except: [:index, :show, :new, :create]

  def index
    @prototype = Prototype.includes(:user)
  end

  def new
    @users = User.new
    @prototype = Prototype.new
  end

  def create
    @prototype = Prototype.new(prototype_params)
    if @prototype.save
      redirect_to root_path
    else
      render :new
    end
  end

  def destroy
    @prototype = Prototype.find(params[:id])
    @prototype.destroy
     redirect_to root_path
  end

  def show
    @prototype = Prototype.find(params[:id])
    @comment = Comment.new
    @comments =Comment.includes(:user)
  end

  def edit
    @prototype = Prototype.find(params[:id])
  end

  def update
    @prototype = Prototype.find(params[:id])
     if @prototype.update(prototype_params)
      redirect_to prototype_path
     else
      render :edit
     end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :profil, :occupation, :position)
  end

  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end

  def move_to_index
    @prototype = Prototype.find(params[:id])
    unless user_signed_in? && @prototype.user == current_user
      redirect_to user_session_path
    end
  end
end
