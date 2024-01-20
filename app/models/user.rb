class User < ApplicationRecord
    has_and_belongs_to_many :rooms, join_table: :accesses
  has_many :logs
  has_one :lost_card

  has_secure_password

  validates :login, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  # Metoda autentykacyjna
  def self.authenticate(login, password)
    user = find_by(login: login)
    return nil unless user
    user.authenticate(password)
  end
end
