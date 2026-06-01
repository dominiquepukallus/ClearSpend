class AddAliasToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :alias
  end
end
