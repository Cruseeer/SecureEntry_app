class CreateAccesses < ActiveRecord::Migration[7.1]
  def change
    create_table :accesses do |t|
      t.belongs_to :user
      t.belongs_to :room

      t.timestamps
    end

    add_index :accesses, [:user_id, :room_id], unique: true
  end
end
