extends Node
## CraftingSystem - Hệ thống chế biến và công thức
## Singleton tự động load

signal recipe_unlocked(recipe_id: String)
signal item_crafted(recipe_id: String, amount: int)

# Recipe structure: {recipe_id: RecipeData}
var recipes: Dictionary = {}
var unlocked_recipes: Array[String] = []

# Recipe data class
class RecipeData:
	var recipe_id: String
	var name: String
	var description: String
	var ingredients: Dictionary  # {item_id: quantity}
	var results: Dictionary  # {item_id: quantity}
	var crafting_time: float = 0.0  # seconds
	var required_building: String = ""  # Building type needed
	var required_level: int = 1

	func _init(p_id: String, p_name: String, p_desc: String = ""):
		recipe_id = p_id
		name = p_name
		description = p_desc
		ingredients = {}
		results = {}

func _ready() -> void:
	print("🔨 Crafting System khởi động!")
	_initialize_recipes()

	# Unlock basic recipes
	unlock_recipe("flour_from_wheat")
	unlock_recipe("bread_from_flour")
	unlock_recipe("animal_feed")

func _initialize_recipes() -> void:
	# Flour from Wheat (at Mill)
	var flour_recipe = RecipeData.new("flour_from_wheat", "Bột mì", "Xay lúa mì thành bột")
	flour_recipe.ingredients = {"wheat": 1}
	flour_recipe.results = {"flour": 1}
	flour_recipe.crafting_time = 5.0
	flour_recipe.required_building = "mill"
	recipes["flour_from_wheat"] = flour_recipe

	# Bread from Flour (at Workshop)
	var bread_recipe = RecipeData.new("bread_from_flour", "Bánh mì", "Nướng bánh mì từ bột")
	bread_recipe.ingredients = {"flour": 2}
	bread_recipe.results = {"bread": 1}
	bread_recipe.crafting_time = 10.0
	bread_recipe.required_building = "workshop"
	recipes["bread_from_flour"] = bread_recipe

	# Cheese from Milk (at Workshop)
	var cheese_recipe = RecipeData.new("cheese_from_milk", "Phô mai", "Làm phô mai từ sữa")
	cheese_recipe.ingredients = {"milk": 3}
	cheese_recipe.results = {"cheese": 1}
	cheese_recipe.crafting_time = 15.0
	cheese_recipe.required_building = "workshop"
	recipes["cheese_from_milk"] = cheese_recipe

	# Animal Feed (at Silo or Workshop)
	var feed_recipe = RecipeData.new("animal_feed", "Thức ăn chăn nuôi", "Trộn nguyên liệu làm thức ăn")
	feed_recipe.ingredients = {"wheat": 2, "corn": 1}
	feed_recipe.results = {"animal_feed": 5}
	feed_recipe.crafting_time = 3.0
	feed_recipe.required_building = "silo"
	recipes["animal_feed"] = feed_recipe

	# Wool Cloth (at Workshop, requires level 2)
	var cloth_recipe = RecipeData.new("cloth_from_wool", "Vải len", "Dệt vải từ len cừu")
	cloth_recipe.ingredients = {"wool": 3}
	cloth_recipe.results = {"cloth": 1}
	cloth_recipe.crafting_time = 20.0
	cloth_recipe.required_building = "workshop"
	cloth_recipe.required_level = 2
	recipes["cloth_from_wool"] = cloth_recipe

	# Honey Cake (at Workshop)
	var honey_cake_recipe = RecipeData.new("honey_cake", "Bánh mật ong", "Làm bánh ngọt từ mật ong")
	honey_cake_recipe.ingredients = {"honey": 1, "flour": 2, "egg": 1}
	honey_cake_recipe.results = {"honey_cake": 1}
	honey_cake_recipe.crafting_time = 12.0
	honey_cake_recipe.required_building = "workshop"
	recipes["honey_cake"] = honey_cake_recipe

	# Premium Animal Feed (advanced)
	var premium_feed = RecipeData.new("premium_feed", "Thức ăn cao cấp", "Thức ăn chất lượng cao")
	premium_feed.ingredients = {"wheat": 1, "corn": 1, "carrot": 1}
	premium_feed.results = {"premium_feed": 3}
	premium_feed.crafting_time = 8.0
	premium_feed.required_building = "silo"
	premium_feed.required_level = 2
	recipes["premium_feed"] = premium_feed

## Unlock a recipe
func unlock_recipe(recipe_id: String) -> bool:
	if not recipes.has(recipe_id):
		push_error("Recipe không tồn tại: " + recipe_id)
		return false

	if recipe_id in unlocked_recipes:
		return false

	unlocked_recipes.append(recipe_id)
	recipe_unlocked.emit(recipe_id)
	print("📜 Đã mở khóa công thức: ", recipes[recipe_id].name)
	return true

## Check if recipe is unlocked
func is_recipe_unlocked(recipe_id: String) -> bool:
	return recipe_id in unlocked_recipes

## Check if can craft (has ingredients)
func can_craft(recipe_id: String) -> bool:
	if not is_recipe_unlocked(recipe_id):
		return false

	if not recipes.has(recipe_id):
		return false

	var recipe: RecipeData = recipes[recipe_id]

	# Check all ingredients
	for item_id in recipe.ingredients.keys():
		var required = recipe.ingredients[item_id]
		if not InventoryManager.has_item(item_id, required):
			return false

	return true

## Craft an item
func craft(recipe_id: String, amount: int = 1) -> bool:
	if not can_craft(recipe_id):
		print("❌ Không thể chế tạo ", recipe_id)
		return false

	var recipe: RecipeData = recipes[recipe_id]

	# Remove ingredients
	for item_id in recipe.ingredients.keys():
		var required = recipe.ingredients[item_id] * amount
		if not InventoryManager.remove_item(item_id, required):
			# Rollback if something fails (shouldn't happen if can_craft passed)
			push_error("Crafting failed: không thể xóa " + item_id)
			return false

	# Add results
	for item_id in recipe.results.keys():
		var produced = recipe.results[item_id] * amount
		InventoryManager.add_item(item_id, produced)

	item_crafted.emit(recipe_id, amount)
	print("✨ Đã chế tạo x", amount, " ", recipe.name)
	return true

## Get recipe by ID
func get_recipe(recipe_id: String) -> RecipeData:
	return recipes.get(recipe_id, null)

## Get all unlocked recipes
func get_unlocked_recipes() -> Array[RecipeData]:
	var result: Array[RecipeData] = []
	for recipe_id in unlocked_recipes:
		if recipes.has(recipe_id):
			result.append(recipes[recipe_id])
	return result

## Get recipes by building type
func get_recipes_for_building(building_type: String) -> Array[RecipeData]:
	var result: Array[RecipeData] = []
	for recipe_id in unlocked_recipes:
		if recipes.has(recipe_id):
			var recipe: RecipeData = recipes[recipe_id]
			if recipe.required_building == building_type:
				result.append(recipe)
	return result

## Get recipe info string
func get_recipe_info(recipe_id: String) -> String:
	if not recipes.has(recipe_id):
		return "Recipe not found"

	var recipe: RecipeData = recipes[recipe_id]
	var info = "%s\n%s\n\nNguyên liệu:\n" % [recipe.name, recipe.description]

	for item_id in recipe.ingredients.keys():
		var required = recipe.ingredients[item_id]
		var has = InventoryManager.get_item_count(item_id)
		var item_name = InventoryManager.get_item_name(item_id)
		info += "  • %s: %d/%d\n" % [item_name, has, required]

	info += "\nKết quả:\n"
	for item_id in recipe.results.keys():
		var amount = recipe.results[item_id]
		var item_name = InventoryManager.get_item_name(item_id)
		info += "  • %s x%d\n" % [item_name, amount]

	if recipe.crafting_time > 0:
		info += "\nThời gian: %.0fs\n" % recipe.crafting_time

	if recipe.required_building != "":
		info += "Cần: %s (Lv.%d)\n" % [recipe.required_building, recipe.required_level]

	return info
