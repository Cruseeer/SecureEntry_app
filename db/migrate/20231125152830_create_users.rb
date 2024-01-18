class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :login
      t.string :password_digest
      t.boolean :isadmin
    end
  end
end