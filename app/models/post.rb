class Post < ApplicationRecord
  belongs_to :user
  belongs_to :condominio
  has_many :comments
  validates :title, presence: true
  validates :body, presence:true, length: {minimum: 3}
end
