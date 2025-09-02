class AddDefaultToArticlesIsBlocked < ActiveRecord::Migration[8.0]
  def change
    change_column_default :articles, :is_blocked, from: nil, to: false
  end
end
