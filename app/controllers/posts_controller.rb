class PostsController < ApplicationController
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
  private
    def post_params
      params.require(:post).permit(:title, :body)
    end
end
