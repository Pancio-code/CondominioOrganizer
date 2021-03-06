class PostsController < ApplicationController
  before_action :set_post, only: %i[ show destroy ]
  before_action :authenticate_user!

  # GET /posts or /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1 or /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  def create
    authorize! :create, Post
    temp_file = post_params["file"]
    if temp_file != nil
      @temp_file_path = temp_file.tempfile
      @condomino = Condomino.find_by(condominio_id: params[:condominio_id],user_id: current_user.id)
      if @condomino.is_condo_admin == true
        if params["post"]["condomino_select"] != nil
          @condomini_selezionati = params["post"]["condomino_select"]
          @Gdrive_controller = GdriveUserItemsController.new
          @Gdrive_controller.inserisci_file(temp_file,params["post"]["condomino_select"])
        end
      else
        @Gdrive_controller = GdriveUserItemsController.new
        @Gdrive_controller.crea_file(temp_file, current_user.email, @condomino)
      end
    end
    @condominio = Condominio.find(params[:condominio_id])
    @post       = @condominio.posts.create(title: params["post"]["title"], body:params["post"]["body"])
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

  # DELETE /posts/1 or /posts/1.json
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
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:title, :body,:file,:condomino_select)
    end
end
