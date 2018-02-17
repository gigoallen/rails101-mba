class GroupsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :find_group_and_check_permission, only: [:edit, :update, :destroy]

  def index
    @groups = Group.all
  end

  def show
    @group = Group.find(params[:id])
    @posts = @group.posts.recent.paginate(page: params[:page], per_page: 5)
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.user = current_user
    if @group.save
      current_user.join!(@group)
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

  #會員參加某個社團
  def join
    @group = Group.find(params[:id])
    if !current_user.is_member_of?(@group)
      current_user.join!(@group)
      flash[:notice] = "加入討論群組成功！"
    else
      flash[:warning] = "你已經是群組成員了！"
    end
    redirect_to group_path(@group)
  end

  #會員參退出個社團
  def quit
    @group = Group.find(params[:id])
    if current_user.is_member_of?(@group)
      current_user.quit!(@group)
      flash[:alert] = "已經退出群組！"
    else
      flash[:warning] = "您本非此群組成員，何來退出？"
    end
    redirect_to group_path(@group)
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
