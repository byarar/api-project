class User < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_secure_password

  validates :username, presence: { message: "Username can't be blank" },
  uniqueness: { message: "Username has already been taken" }
end
