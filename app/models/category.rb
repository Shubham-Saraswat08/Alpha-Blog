class Category < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  has_many :article_categories
  has_many :articles, through: :article_categories
end
