class RemoveCommentFromFavorites < ActiveRecord::Migration[6.1]
  def change
    remove_column :favorites, :comment, :text
  end
end
