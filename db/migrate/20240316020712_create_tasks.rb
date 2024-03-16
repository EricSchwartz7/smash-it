class CreateTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :tasks do |t|
      t.text :description
      t.boolean :is_complete, default: false
      t.integer :list_id

      t.timestamps
    end
  end
end
