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

  def bulk_destroy
    seeded_names = ["Entertainment", "Well-being", "News & Information", "Food & Delivery / Meal kits",
                    "Software & Productivity", "Shopping & Retail"]
    to_delete = Category.where(id: params[:category_ids]).where.not(name: seeded_names)
    @deleted_ids = to_delete.pluck(:id)  # save IDs first
    to_delete.destroy_all
    @deleted_categories = @deleted_ids   # pass IDs to the view
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to subscriptions_path }
    end
  end

  def create
    if Category.where.not(name: ["Entertainment", "Well-being", "News & Information", "Food & Delivery / Meal kits",
                                 "Software & Productivity", "Shopping & Retail", "Customized"]).count >= 6
      redirect_to subscriptions_path, alert: "You have reached the maximum of 6 custom categories."
      return
    end
    @category = Category.new(category_params)
    if @category.save
      redirect_to subscriptions_path, notice: "Category created!"
    else
      render :new, status: :unprocessable_entity
    end
  end
end

private

def category_params
  params.require(:category).permit(:name, :color)
end
