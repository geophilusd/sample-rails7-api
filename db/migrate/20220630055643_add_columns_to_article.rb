class AddColumnsToArticle < ActiveRecord::Migration[7.0]
  def change
    add_column :articles, :word_count, :integer, default: 0
    add_column :articles, :approved, :boolean, default: false
  end
end
