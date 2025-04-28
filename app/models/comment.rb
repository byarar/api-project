class Comment < ApplicationRecord
  belongs_to :post

  validates :post_id, presence: true
  validates :body, presence: true
end


