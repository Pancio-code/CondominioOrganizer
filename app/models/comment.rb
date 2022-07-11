class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user
  belongs_to :condominio
  validates :body, presence: true, length: { minimum: 3}
end
