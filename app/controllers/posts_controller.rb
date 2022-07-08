class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_request, only: %i[create destroy]
  def create
    @condominio = Condominio.find(params[:condominio_id])
    @post       = @condominio.posts.create(post_params)
    @post.user_id = current_user.id
    if @post.save
      redirect_to condominio_path(@condominio)
    else
      flash.now[:danger] = "error"
    end
  end

  def destroy
    authorize! :destroy, Post
    @condominio = Condominio.find(params[:condominio_id])
    @post = @condominio.posts.find(params[:id])
    @post.destroy
    redirect_to condominio_path(@condominio)
  end

  private
    def post_params
      params.require(:post).permit(:title, :body)
    end
end
