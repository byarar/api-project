class Comment < ApplicationRecord
  belongs_to :post

  validates :post_id, presence: { message: "Post must be associated with a comment" }
  validates :body, presence: { message: "Body can't be blank" }
end


