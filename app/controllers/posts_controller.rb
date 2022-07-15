class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]
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

  # GET /posts/1/edit
  def edit
  end

  def create
    authorize! :create, Post
    temp_file = post_params["file"]
    if temp_file != nil
      @temp_file_path = temp_file.tempfile
      if Condomino.where(condominio_id: params[:condominio_id],user_id: current_user.id,is_condo_admin: true).exists?
        if params["post"]["condomino_select"] != nil
          @condomini_selezionati = params["post"]["condomino_select"]
          @Gdrive_controller = GdriveUserItemsController.new
          @Gdrive_controller.update(params[:condominio_id],params[:user_id],"eleva",nil)
        end
      else
        @Gdrive_controller = GdriveUserItemsController.new
        @Gdrive_controller.crea_file(temp_file, current_user.email, @condomino)
      end
    end
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

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to post_url(@post), notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
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
