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

  def create
    @category = current_user.categories.new(category_params)
    if @category.save
      redirect_to categories_path, notice: "category created"
    else
      @mode = "manual"
      flash.now[:alert] = "Failed to add category"
      render "categories/new", status: :unprocessable_entity
    end
  end
end
