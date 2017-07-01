require 'test_helper'

class RecipesEditTest < ActionDispatch::IntegrationTest

  def setup
    @chef = Chef.create!(chefname: "jakov", email: "jakov@invita.hr", password: "password", password_confirmation: "password")
    @recipe = Recipe.create(name: "vegetables saute", description: "great vegetables saute something...", chef: @chef)
  end
  
  test "reject invalid recipe update" do
    sign_in_as(@chef, "password")
    get edit_recipe_path(@recipe)
    assert_template 'recipes/edit'
    patch recipe_path(@recipe), params: { recipe: { name: " ", description: "some description" } }
    assert_template 'recipes/edit'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end

  test "successfully edit a recipe" do
    sign_in_as(@chef, "password")
    get edit_recipe_path(@recipe)
    assert_template 'recipes/edit'
    name_of_recipe = "Chicken saute"
    description_of_recipe = "Chicken, vegetables, something, something, something"
    patch recipe_path(@recipe), params: { recipe: { name: name_of_recipe, description: description_of_recipe } }
    assert_redirected_to @recipe
    #follow_redirect!
    assert_not flash.empty?
    @recipe.reload
    assert_match name_of_recipe, @recipe.name
    assert_match description_of_recipe, @recipe.description
  end
  
end
