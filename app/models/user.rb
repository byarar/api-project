class User < ApplicationRecord
  has_many :posts, dependent: :destroy

  validates :username, presence: { message: "Username can't be blank" },
  uniqueness: { message: "Username has already been taken" }
end
