class CreateTable < ActiveRecord::Migration[5.0]
  def change
    create_table(:ingredients) do |t|
      t.column(:name, :string)
      t.timestamps()
    end

    create_table(:recipes) do |t|
      t.column(:name, :string)
      t.column(:instruction, :string)
      t.timestamps()
    end

    create_table(:quantities) do |t|
      t.column(:recipe_id, :integer)
      t.column(:ingredient_id, :integer)
      t.column(:quantity, :integer)
      t.timestamps()
    end

    create_table(:ratings) do |t|
      t.column(:rate, :integer)
      t.column(:recipe_id, :integer)
      t.timestamps()
    end

    create_table(:tags) do |t|
      t.column(:name, :string)
      t.timestamps()
    end

    create_table(:recipe_tags) do |t|
      t.column(:recipe_id, :integer)
      t.column(:tag_id, :integer)
      t.timestamps()
    end
  end
end
