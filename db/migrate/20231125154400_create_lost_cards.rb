class CreateLostCards < ActiveRecord::Migration[7.1]
  def change
    create_table :lost_cards do |t|
      t.datetime :time
      t.string :description
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
