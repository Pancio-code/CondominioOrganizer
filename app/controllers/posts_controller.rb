class PostsController < ApplicationController
  before_action :authenticate_user!
  #before_action :set_request, only: %i[create destroy]
  def create
    @condominio = Condominio.find(params[:condominio_id])
    @post       = @condominio.posts.create(post_params)
    @post.user_id = current_user.id
    respond_to do |format|
      if @post.save!
        format.html { redirect_to condominio_path(@condominio), notice: "Post creato correttamente." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize! :Destroy, Post
    @condominio = Condominio.find(params[:condominio_id])
    @post = @condominio.posts.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to condominio_path(@condominio), notice: "Post eliminato correttamente." }
      format.json { head :no_content }
    end
  end

  private
    def post_params
      params.require(:post).permit(:title, :body)
    end
end
