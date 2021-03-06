class TasksController < ApplicationController
  before_action :set_task, only: [:show,:edit,:update,:destroy]
  before_action :require_user_logged_in, only: [:index,:show,:edit,:update,:destroy]
  
  def index
    @user = current_user
    @task = current_user.tasks.build
    @tasks = current_user.tasks.order('created_at DESC').page(params[:page])
  end
  
  
  def show
  end
  
  def new
    @task = Task.new
  end
  
  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      flash[:success] = 'タスクが正常に投稿されました'
      redirect_to @task
    else
      flash.now[:danger] = 'タスクが投稿されませんでした'
      render :new
    end
  end
  
  def edit
  end
  
  def update 
    
    if @task.update(task_params)
      flash[:success] = 'タスクは正常に更新されました'
      redirect_to @task
    else
      flash.now[:danger] = 'タスクの更新に失敗しました'
      render :edit
    end
  end
  
  def destroy
    
    @task.destroy
    
    flash[:success] = 'タスクは正常に削除されました'
    redirect_to root_url
  end
  
   private
   
   def set_task
#     @task = Task.find(params[:id])
     
     @task = current_user.tasks.find_by(id: params[:id])
     
     if (@task == nil)
       redirect_to root_url
     end
   end
  
 
   def task_params
     params.require(:task).permit(:content,:status)
   end
    
end


