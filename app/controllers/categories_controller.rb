class CategoriesController < ApplicationController
  def index
    @categories = Category.all
  end

  def show
    @category = Category.find(params[:id])
    @subscriptions = @category.subscriptions.where(user: current_user).order(:name)
  end
end
