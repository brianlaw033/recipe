class AddColumnAvgRating < ActiveRecord::Migration[5.0]
  def change
    add_column(:recipes, :avg_rating, :integer)
  end
end
