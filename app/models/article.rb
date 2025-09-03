class Article < ApplicationRecord
  belongs_to :user
  validates :title, presence: true, uniqueness: { scope: :user_id, case_sensitive: false, message: "You already have an article with this title." }
  validates :content, presence: true, length: { minimum: 10, maximun: 500 }

  has_many :article_categories
  has_many :categories, through: :article_categories

  has_rich_text :content

  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
end
