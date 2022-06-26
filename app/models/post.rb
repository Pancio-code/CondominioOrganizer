class Post < ApplicationRecord
  belongs_to :condominio

  validates :title, presence: true
  validates :body, presence: true, length: { minimum: 3 }
end
