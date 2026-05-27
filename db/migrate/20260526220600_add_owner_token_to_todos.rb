class AddOwnerTokenToTodos < ActiveRecord::Migration[8.0]
  def change
    add_column :todos, :owner_token, :string
    add_index :todos, :owner_token
  end
end
