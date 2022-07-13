class Post < ApplicationRecord
  belongs_to :user
  belongs_to :condominio
  has_many :comments, dependent: :destroy
  validates :title, presence: true , length: {minimum: 3, maximum: 25}
  validates :body, presence:true, length: {minimum: 3}
end
