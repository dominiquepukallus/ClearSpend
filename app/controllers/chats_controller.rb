class ChatsController < ApplicationController
  def index
    @chats = Chat.all.order(created_at: :desc)
  end

  def show
    @chats = Chat.all.order(created_at: :desc)
    @chat = Chat.find(params[:id])
    @message = Message.new
  end

  def create
    @chat = Chat.create!(
      title: "New Chat",
      chat_date: Time.current,
      user: current_user
    )
    redirect_to chat_path(@chat)
  end
end
