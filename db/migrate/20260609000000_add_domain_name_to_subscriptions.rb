class AddDomainNameToSubscriptions < ActiveRecord::Migration[8.1]
  def change
    add_column :subscriptions, :domain_name, :string
  end
end
