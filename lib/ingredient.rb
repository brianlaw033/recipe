class Ingredient < ActiveRecord::Base
  has_many :quantities, dependent: :destroy
  has_many :recipes, through: :quantities
end
