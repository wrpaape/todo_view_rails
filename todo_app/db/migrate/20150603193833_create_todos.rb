class CreateTodos < ActiveRecord::Migration
  def change
    create_table :todos do |t|
      t.boolean :done, default: false
      t.text :body

      t.timestamps null: false
    end
  end
end
