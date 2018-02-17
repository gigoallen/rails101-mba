class GroupsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :find_group_and_check_permission, only: [:edit, :update, :destroy]

  def index
    @groups = Group.all
  end

  def show
    @group = Group.find(params[:id])
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.user = current_user
    if @group.save
      redirect_to groups_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @group.update(group_params)
      flash[:success] = "Update success"
      redirect_to groups_path, notice: "Update success 更新成功了"
    else
      render :edit
    end
  end

  def destroy
    if @group.destroy
      flash[:alert] = "Group deleted"
      redirect_to groups_path, notice: "刪除成功了！"
    else
      render :index
    end
  end

  private
  def group_params
    params.require(:group).permit(:title, :description)
  end

  def find_group_and_check_permission
    @group = Group.find(params[:id])
    if current_user != @group.user
      redirect_to root_path, alert: "沒有權限修改"
    end
  end
end
