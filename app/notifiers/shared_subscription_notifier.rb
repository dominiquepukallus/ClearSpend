# To deliver this notification:
#
# SharedSubscriptionNotifier.with(record: @post, message: "New post").deliver(User.all)

class SharedSubscriptionNotifier < ApplicationNotifier
  deliver_by :database

  required_param :shared_subscription
  required_param :sender

  # def message
  #   "#{params[:sender].name} has shared #{params[:shared_subscription]} with you."
  # end
  notification_methods do
    def message

     "#{params[:sender].first_name} has shared #{params[:shared_subscription].subscription.name} with you."
    end

    def url
      shared_subscription_path
    end
  end
end
