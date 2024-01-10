class User < ApplicationRecord
  has_and_belongs_to_many :rooms, :join_table => :accesses
  has_many :logs
  has_one :lost_card
end
