class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user

  validates :post_id, presence: { message: "Post must be associated with a comment" }
  validates :body, presence: { message: "Body can't be blank" }
  validates :user_id, presence: { message: "User must be associated with a comment" }
end


