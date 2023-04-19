class ToysController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :load_entities

  after_action :auto_clean, only: [:create, :update]

  rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :handle_invalid

  def index
    @toys = Toy.all
    respond_to do |format|
      format.html
      format.json { render json: @toys }
    end
  end

  def new
    @toy = Toy.new
    respond_to do |format|
      format.html
      format.json { render json: @toy }
    end
  end

  def create
    data = params.require(:toy).permit(:name, :description)
    @toy = Toy.new(data)
    if @toy.save
      flash[:success] = "Toy #{@toy.name} was created successfully"
      respond_to do |format|
        format.html { redirect_to toys_path }
        format.json { render json: @toy, status: :ok }
      end
    else
      respond_to do |format|
        format.html { redirect_to toys_path }
        format.json { render json: @toy.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: @toy, status: :ok }
    end
  end

  def edit
    respond_to do |format|
      format.html
      format.json { render json: @toy, status: :ok }
    end
  end

  def update
    if @toy.update(params.require(:toy).permit(:name).permit(:description))
      flash[:success] = "Toy #{@toy.name} was updated successfully"
      respond_to do |format|
        format.html { redirect_to toy_path(@toy) }
        format.json { render :json, status: :success }
      end
    else
      format.html { redirect_to toy_path(@toy) }
      format.json { render json: @toy.errors, status: :unprocessable_entity }
    end
  end

  def destroy
    @toy.destroy
    respond_to do |format|
      format.html { redirect_to toys_path, status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  def handle_not_found
    respond_to do |format|
      format.html { redirect_to toys_path && return }
      format.json { render json: { errors: ['Not found'] }, status: :not_found }
    end
  end

  def handle_invalid
    respond_to do |format|
      format.html { redirect_to toys_path }
      format.json { render json: { errors: @toy.errors }, status: :unprocessable_entity }
    end
  end

  def load_entities
    @toys = Toy.all
    @toy = Toy.find(params[:id]) if params[:id]
  end

end
