class AddUserIdToLists < ActiveRecord::Migration[7.1]
  def change
    add_column :lists, :user_id, :integer
  end
end
