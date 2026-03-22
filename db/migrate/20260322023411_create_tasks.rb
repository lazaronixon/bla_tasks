class CreateTasks < ActiveRecord::Migration[8.1]
  def change
    create_table :tasks do |t|
      t.string :title, null: false
      t.string :description, null: false
      t.string :status, null: false, default: "created"
      t.date :due_date
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
