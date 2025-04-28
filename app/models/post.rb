class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy

  validates :user_id, presence: { message: "User must be associated with a post" }
  validates :title, presence: { message: "Title can't be blank" }
  validates :body, presence: { message: "Body can't be blank" }
end

