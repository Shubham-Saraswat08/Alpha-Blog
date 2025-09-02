class AddIsBlockedToArticles < ActiveRecord::Migration[8.0]
  def change
    add_column :articles, :is_blocked, :boolean
  end
end
