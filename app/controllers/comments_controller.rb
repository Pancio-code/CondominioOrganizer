class CommentsController < ApplicationController
  before_action :set_comment, only: %i[ show destroy ]
  before_action :authenticate_user!

  # GET /comments or /comments.json
  def index
    @comments = Comment.all
  end

  # GET /comments/1 or /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    @comment = Comment.new
  end

  # POST /comments or /comments.json
  def create
    authorize! :create, Comment
    @post = Post.find(params[:post_id])
    @comment = @post.comments.create(comment_params)
    @comment.user_id = current_user.id
    @comment.condominio_id = @post.condominio_id
    #@comment = Comment.new(comment_params)
    
    respond_to do |format|
      if @comment.save
        format.html { redirect_to post_url(@post), notice: "Commento creato con successo." }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1 or /comments/1.json
  def destroy
    authorize! :Destroy, Comment
    @post_redirect = @comment.post
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to @comment.post, notice: "Commento cancellato correttamente" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def comment_params
      params.require(:comment).permit(:body)
    end
end
