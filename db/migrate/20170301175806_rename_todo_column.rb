class RenameTodoColumn < ActiveRecord::Migration[5.0]
  def change
    rename_column :todos, :crated_by, :created_by
  end
end
