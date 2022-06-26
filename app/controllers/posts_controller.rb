class PostsController < ApplicationController
  def create
    @condominio = Condominio.find(params[:condominio_id])
    @post       = @condominio.posts.create(post_params)
    redirect_to condominio_path(@condominio)
  end
  private
    def post_params
      params.require(:post).permit(:title, :body)
    end
end
