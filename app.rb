require("bundler/setup")
  Bundler.require(:default)

  Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }
  also_reload("lib/*.rb")
require('pry')
DB = PG.connect({:dbname => "recipe_box_development"})

get ('/') do
  @recipes = Recipe.all().order('updated_at DESC')
  @top_recipes = DB.exec('SELECT recipes.* ,avg(rate) FROM ratings JOIN recipes ON (recipes.id = ratings.recipe_id) GROUP BY recipes.id ORDER BY avg(rate) desc;')
  @tags = Tag.all().order('name')
  @ingredients = Ingredient.all().order('name')
  erb(:index)
end

post('/tag') do
  url = params.fetch('tag_id')
  redirect to ("#{url}")
end

post('/ingredient') do
  url = params.fetch('ingredient_id')
  redirect to ("#{url}")
end

post('/new/recipe') do
  name = params.fetch('name')
  recipe = Recipe.create({:name=> name, :avg_rating => 0})
  redirect to ('/')
end

get ('/recipe/:id') do
  id = params.fetch('id')
  @recipe = Recipe.find(id)
  @tags = Tag.all()
  @@ingredients = Ingredient.all()
  @rating = @recipe.cal_rating()
  erb(:recipe)
end

patch ('/add_instructions/:id') do
  recipe_id = Integer(params.fetch('id'))
  recipe = Recipe.find(recipe_id)
  instruction = params.fetch('instruction')
  tag_id = params.fetch('tag_id')
  new_tag = params.fetch('new_tag')
  ingredient_ids = params["ingredient_ids"]
  new_ingredient = params.fetch('new_ingredient')
  quantities = params.fetch("quantities")
  recipe.addRecipe(instruction, tag_id, new_tag, ingredient_ids, new_ingredient, quantities)
  redirect to ("/recipe/#{recipe_id}")
end

patch('/add_ratings/:id') do
  recipe_id = Integer(params.fetch('id'))
  recipe = Recipe.find(recipe_id)
  rating = Integer(params.fetch('new_rating'))
  Rating.create({:rate => rating, :recipe => recipe})
  recipe.update(:avg_rating => recipe.cal_rating())
  redirect to ("/recipe/#{recipe_id}")
end

delete ('/delete/recipe/:id') do
  id = params.fetch('id')
  recipe = Recipe.find(id)
  recipe.destroy()
  redirect to ("/")
end

get('/tag/:id') do
  id = Integer(params.fetch('id'))
  @tag = Tag.find(id)
  erb(:tag)
end

delete ('/delete/tag/:id') do
  id = params.fetch('id')
  tag = Tag.find(id)
  tag.destroy()
  redirect to ("/")
end

get('/ingredient/:id') do
  id = Integer(params.fetch('id'))
  @ingredient = Ingredient.find(id)
  erb(:ingredient)
end

delete ('/delete/ingredient/:id') do
  id = params.fetch('id')
  ingredient = Ingredient.find(id)
  ingredient.destroy()
  redirect to ("/")
end
