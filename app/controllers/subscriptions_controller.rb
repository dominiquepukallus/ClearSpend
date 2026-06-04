class SubscriptionsController < ApplicationController
  def index
    @current_month = params[:month] ? Date.parse(params[:month]) : Date.today.beginning_of_month
    @subscriptions = current_user.subscriptions.where(status: "active")
  end

  def show
    @subscription = Subscription.find(params[:id])
  end

  def new
    @subscription = Subscription.new
    @mode = params[:mode]
  end

  def create
    @subscription = current_user.subscriptions.new(subscription_params)
    if @subscription.save
      redirect_to subscriptions_path, notice: "Subscription created"
    else
      @mode = "manual"
      flash.now[:alert] = "Failed to add subscription"
      render "subscriptions/new", status: :unprocessable_entity
    end
  end

  def edit
    @subscription = Subscription.find(params[:id])
  end

  def update
    @subscription = Subscription.find(params[:id])
    if @subscription.update(subscription_params)
      redirect_to subscriptions_path, notice: "Subscription updated"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @subscription = Subscription.find(params[:id])
    @subscription.destroy
    redirect_to subscriptions_path
  end

  def parse_csv
    csv_file = params[:csv_file]
    if csv_file.nil?
      render turbo_stream: turbo_stream.replace(
        "preview",
        html: "<div class='bg-red-100 text-red-700 p-4 rounded'>No file uploaded</div>"
      )
      return
    end
    csv_content = csv_file.read
    parser = AiCsvParser.new(csv_content)
    @parsed_subscriptions = parser.parse
    ai_turbo_stream
  end

  def import_csv
    parsed_data = JSON.parse(params[:parsed_data])
    parsed_data.each do |sub_data|
      if sub_data["category"].present?
        category = Category.find_by_name_case_insensitive(sub_data["category"])
        sub_data["category_id"] = category&.id
        sub_data.delete("category")
      end
      sub_data["status"] = "active"
      current_user.subscriptions.create!(sub_data)
    end
    redirect_to subscriptions_path, notice: "Subscriptions imported successfully"
  end

  def bulk_create
    subscription_params = params[:subscriptions]
    created = []
    errors = []

    subscription_params.each do |index, sub_params|
      subscription = current_user.subscriptions.new(
        name: sub_params[:name],
        amount: sub_params[:amount],
        billing_cycle: sub_params[:billing_cycle],
        date_recurrence: sub_params[:date_recurrence],
        category_id: sub_params[:category_id],
        status: "active"
      )
      if subscription.save
        created << subscription
      else
        errors << "Subscription #{index.to_i + 1}: #{subscription.errors.full_messages.join(', ')}"
      end
    end
    if errors.empty?
      redirect_to subscriptions_path, notice: "##{created.count}: subscriptions added!"
    else
      redirect_to new_subscription_path(mode: "bulk_upload"),
      alert: "Failed to add subscription. Errors: #{errors.join(', ')}"
    end
  end

  private

  def subscription_params
    params.require(:subscription).permit(:name, :date_recurrence, :amount, :billing_cycle, :status, :category_id)
  end

  def ai_turbo_stream
    render turbo_stream: turbo_stream.replace(
      "preview",
      partial: "preview_table",
      locals: { subscriptions: @parsed_subscriptions }
    )
  rescue StandardError => e
    render turbo_stream: turbo_stream.replace(
      "preview",
      html: "<div class='bg-red-100 text-red-700 p-4 rounded'>Error parsing CSV: #{e.message}</div>"
    )
  end
end
