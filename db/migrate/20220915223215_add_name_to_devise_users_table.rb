class AddNameToDeviseUsersTable < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :name, :string, default: "user"
  end
end
