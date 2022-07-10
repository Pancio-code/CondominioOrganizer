class Post < ApplicationRecord
  belongs_to :condominio
  belongs_to :user
  has_many :comments
  validates :title, presence: true
  validates :body, presence: true, length: { minimum: 3 }
end
