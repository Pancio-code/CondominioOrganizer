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

  def destroy
    @post.destroy

    respond_to do |format|
      Post.where(id: @post.id).destroy_all
      format.html { redirect_to condominios_url, notice: "Post cancellato." }
      format.json { head :no_content }
    end
  end
  private
    def post_params
      params.require(:post).permit(:title, :body)
    end
end
