class MessagesController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!

  def create
    @chat = Chat.find(params[:chat_id])
    @message = Message.new(message_params)
    @message.chat = @chat
    @message.role = "user"

    if @message.save
      generate_ai_response
      respond_to do |format|
        format.json {
          render json: {
            message: @assistant_message,
            content: @assistant_message.content
          }
        }
        format.html { redirect_to chat_path(@chat) }
      end
    else
      respond_to do |format|
        format.json {
          render json: { errors: @message.errors.full_messages }, status: :unprocessable_entity
        }
        format.html {
          @chat = @message.chat
          render 'chats/show'
        }
      end
    end
  end

  private

  def generate_ai_response
    @ruby_llm = RubyLLM.chat

    ToolRegistry.register_all(@ruby_llm)

    instructions = system_instructions + "\n\nIMPORTANT: When calling tools, always use user_id: #{@chat.user_id}"

    # @ruby_llm.with_tool(GetAllSubscriptions.new)
    # @ruby_llm.with_tool(GetUpcomingBills.new)

    response = @ruby_llm.with_instructions(instructions)
                      .ask(@message.content)

                      suggestions = extract_subscription_suggestions(response.content)

    @assistant_message = Message.create(
      role: "assistant",
      chat: @chat,
      content: response.content,
      metadata: { suggestions: suggestions }
    )
  end

  def extract_subscription_suggestions(content)
    user = @chat.user
    suggestions = []

    content.scan(/\/subscriptions\/(\d+)/).each do |match|
      sub_id = match[0].to_i
      subscription = user.subscriptions.find_by(id: sub_id)

      if subscription
        suggestions << {
        type: "subscription",
        id: subscription.id,
        name: subscription.name,
        amount: subscription.amount.to_f,
        next_billing_date: subscription.next_billing_date&.to_s,
        url: Rails.application.routes.url_helpers.subscription_path(subscription)
      }
      end
    end
    suggestions.uniq { |s| s[:id] }
  end

  def system_instructions
    <<~TEXT
      You are a helpful ClearSpend assistant that helps users manage their subscriptions.

      You have access to tools to fetch real subscription data.

      When user asks about:
      - Account overview, insights, analytics → use get_account_insights
      - Adding/creating/uploading new subscription → use get_add_subscription_link
      - All subscriptions → use get_all_subscriptions
      - Upcoming bills → use get_upcoming_bills

      When you have data:
      - Be specific with amounts and dates
      - Always include markdown links like [View Netflix](/subscriptions/123), [Add subscription](/subscriptions/new) or [View Insights]()
      - Format numbers with dollar signs
      - Be clear and concise

      Examples:
      - "You have 3 subscriptions totaling $87/month. Your most expensive is [Netflix](/subscriptions/1) at $20."
      - "To add a new subscription, [click here](/subscriptions/new)."

    TEXT
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
