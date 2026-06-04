class SubscriptionsController < ApplicationController
  def index
    @subscriptions = current_user.subscriptions
  end

  def show
    @subscription = Subscription.find(params[:id])
  end

  def new
    @subscription = Subscription.new
    @mode = params[:mode] || "manual_upload"
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
    puts "CSV SCAN DEBUG"
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
    @subscriptions = parser.parse
    ai_turbo_stream
  end

  private

  def subscription_params
    params.require(:subscription).permit(:name, :date_recurrence, :amount, :billing_cycle, :status, :category_id)
  end

  def ai_turbo_stream
    render turbo_stream: turbo_stream.replace(
      "preview",
      partial: "preview_table",
      locals: { subscriptions: @subscriptions }
    )
  rescue StandardError => e
    render turbo_stream: turbo_stream.replace(
      "preview",
      html: "<div class='bg-red-100 text-red-700 p-4 rounded'>Error parsing CSV: #{e.message}</div>"
    )
  end
end
