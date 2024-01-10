class Room < ApplicationRecord
  has_and_belongs_to_many :users, :join_table => :accesses
  has_many :logs
end
