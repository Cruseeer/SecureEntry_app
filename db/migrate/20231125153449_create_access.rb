class CreateAccess < ActiveRecord::Migration[7.1]
  def change
    create_table :accesses, id: false do |t|
      t.belongs_to :user, index: true
      t.belongs_to :room, index: true
    end
  end
end
