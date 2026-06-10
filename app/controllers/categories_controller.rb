class CategoriesController < ApplicationController
  def index
    @categories = Category.all
  end

  def show
    @category = Category.find(params[:id])
    @subscriptions = @category.subscriptions.where(user: current_user).order(:name)
  end

  def new
    @category = Category.new
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove("category_#{@category.id}") }
      format.html { redirect_to categories_path }
    end
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to categories_path, notice: "Category created!"
    else
      render :new, status: :unprocessable_entity
    end
  end
end

private

def category_params
  params.require(:category).permit(:name, :color)
end
