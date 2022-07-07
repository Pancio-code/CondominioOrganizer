class CommentsController < ApplicationController
  before_action :authenticate_user!
  
  def create
    authorize! :create, Comment
    @post = Post.find(params[:post_id])
    @commento = @post.comments.create(post_params)
    @commento.user_id = current_user.id
    if @comments.save
      redirect_to condominio_path(Condominio.find(params[:condominio_id]))
    else
      flash.now[:danger] = "Errore creazione commento"
    end
  end

  def destroy
    authorize! :destroy, Comment
    @post = Post.find(params[:post_id])
    @commento = @post.comments.find(params[:id])
    @commento.destroy
    redirect_to condominio_path(Condominio.find(params[:condominio_id]))
  end

  private
    def comment_params
      params.require(:comment).permit(:body)
    end
end
