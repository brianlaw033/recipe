class Recipe < ActiveRecord::Base
  has_many :quantities, dependent: :destroy
  has_many :ingredients, through: :quantities
  has_many :ratings, dependent: :destroy
  has_many :recipe_tags, dependent: :destroy
  has_many :tags, through: :recipe_tags


  def addRecipe(instruction, tag_id, new_tag, ingredient_ids, new_ingredient, quantities)
    quantities.delete("")
    if instruction != ""
      self.update(:instruction =>instruction)
    end
    if new_tag != ""
      new_tag = Tag.create({:name => new_tag})
      RecipeTag.create({:recipe => self, :tag => new_tag})
    end
    if tag_id != ""
      tag = Tag.find(Integer(tag_id))
      RecipeTag.create({:recipe => self, :tag => tag})
    end
    if new_ingredient != ""
      new_ingredient = Ingredient.create({:name => new_ingredient})
      if ingredient_ids != nil
        ingredient_ids.push(new_ingredient.id)
      else
        ingredient_ids = []
        ingredient_ids.push(new_ingredient.id)
      end
    end
    self.createIngredient(ingredient_ids, quantities)
  end

  def createIngredient(ingredient_ids, quantities)
    length = ingredient_ids.length - 1
    for i in 0..length
      ingredient = Ingredient.find(Integer(ingredient_ids[i]))
      quantity = quantities[i]
      Quantity.create({:recipe => self, :ingredient => ingredient, :quantity => quantity})
    end
  end

  def cal_rating()
    total = 0
    length = self.ratings.length
    if length != 0
      self.ratings.each do |rating|
        total += rating.rate
      end
      result = total/length
    else
      result = 0
    end
  end
end
