extends Node
## SaveSystem - Hệ thống lưu/load game hoàn chỉnh

signal game_saved(slot: int)
signal game_loaded(slot: int)
signal save_failed(error: String)

const SAVE_DIR = "user://saves/"
const MAX_SAVE_SLOTS = 3
const SAVE_VERSION = "1.0"

# Save data structure
class SaveData:
	var version: String = SAVE_VERSION
	var timestamp: int
	var playtime: float
	var screenshot: String  # Base64 encoded

	# Game state
	var player_data: Dictionary
	var farm_data: Dictionary
	var inventory_data: Dictionary
	var buildings_data: Array
	var animals_data: Array
	var game_manager_data: Dictionary
	var weather_data: Dictionary

func _ready() -> void:
	_ensure_save_directory()
	print("💾 Save System khởi động!")

func _ensure_save_directory() -> void:
	var dir = DirAccess.open("user://")
	if not dir.dir_exists("saves"):
		dir.make_dir("saves")

## Save game to slot
func save_game(slot: int = 0) -> bool:
	if slot < 0 or slot >= MAX_SAVE_SLOTS:
		push_error("Invalid save slot: " + str(slot))
		save_failed.emit("Invalid slot")
		return false

	var save_data = SaveData.new()
	save_data.timestamp = Time.get_unix_time_from_system()
	save_data.playtime = _get_playtime()

	# Collect all game data
	save_data.game_manager_data = _save_game_manager()
	save_data.inventory_data = _save_inventory()
	save_data.player_data = _save_player()
	save_data.farm_data = _save_farm_plots()
	save_data.buildings_data = _save_buildings()
	save_data.animals_data = _save_animals()
	save_data.weather_data = _save_weather()

	# Take screenshot
	save_data.screenshot = await _capture_screenshot()

	# Save to file
	var save_path = SAVE_DIR + "save_" + str(slot) + ".sav"
	var file = FileAccess.open(save_path, FileAccess.WRITE)

	if not file:
		push_error("Cannot create save file: " + save_path)
		save_failed.emit("Cannot create file")
		return false

	# Convert to JSON
	var json_data = _save_data_to_dict(save_data)
	var json_string = JSON.stringify(json_data, "\t")
	file.store_string(json_string)
	file.close()

	print("💾 Game saved to slot ", slot)
	game_saved.emit(slot)
	return true

## Load game from slot
func load_game(slot: int = 0) -> bool:
	if slot < 0 or slot >= MAX_SAVE_SLOTS:
		push_error("Invalid save slot: " + str(slot))
		return false

	var save_path = SAVE_DIR + "save_" + str(slot) + ".sav"

	if not FileAccess.file_exists(save_path):
		print("⚠️ No save file in slot ", slot)
		return false

	var file = FileAccess.open(save_path, FileAccess.READ)
	if not file:
		push_error("Cannot open save file: " + save_path)
		return false

	var json_string = file.get_as_text()
	file.close()

	var json = JSON.new()
	var parse_result = json.parse(json_string)

	if parse_result != OK:
		push_error("Failed to parse save file")
		save_failed.emit("Corrupted save file")
		return false

	var data = json.data

	# Version check
	if data.get("version", "") != SAVE_VERSION:
		print("⚠️ Save file version mismatch")
		# Could implement migration here

	# Load all data
	_load_game_manager(data.get("game_manager_data", {}))
	_load_inventory(data.get("inventory_data", {}))
	_load_player(data.get("player_data", {}))
	_load_farm_plots(data.get("farm_data", {}))
	_load_buildings(data.get("buildings_data", []))
	_load_animals(data.get("animals_data", []))
	_load_weather(data.get("weather_data", {}))

	print("📂 Game loaded from slot ", slot)
	game_loaded.emit(slot)
	return true

## Delete save slot
func delete_save(slot: int) -> bool:
	var save_path = SAVE_DIR + "save_" + str(slot) + ".sav"

	if not FileAccess.file_exists(save_path):
		return false

	var dir = DirAccess.open(SAVE_DIR)
	var err = dir.remove(save_path)

	if err == OK:
		print("🗑️ Deleted save slot ", slot)
		return true
	else:
		push_error("Failed to delete save: " + str(err))
		return false

## Check if save exists
func save_exists(slot: int) -> bool:
	var save_path = SAVE_DIR + "save_" + str(slot) + ".sav"
	return FileAccess.file_exists(save_path)

## Get save info without loading
func get_save_info(slot: int) -> Dictionary:
	if not save_exists(slot):
		return {}

	var save_path = SAVE_DIR + "save_" + str(slot) + ".sav"
	var file = FileAccess.open(save_path, FileAccess.READ)

	if not file:
		return {}

	var json_string = file.get_as_text()
	file.close()

	var json = JSON.new()
	if json.parse(json_string) != OK:
		return {}

	var data = json.data

	return {
		"slot": slot,
		"timestamp": data.get("timestamp", 0),
		"playtime": data.get("playtime", 0.0),
		"day": data.get("game_manager_data", {}).get("current_day", 1),
		"money": data.get("game_manager_data", {}).get("money", 0),
		"season": data.get("game_manager_data", {}).get("current_season", "spring"),
		"screenshot": data.get("screenshot", "")
	}

## Get all saves info
func get_all_saves_info() -> Array:
	var saves = []
	for i in MAX_SAVE_SLOTS:
		var info = get_save_info(i)
		if info.size() > 0:
			saves.append(info)
		else:
			saves.append({"slot": i, "empty": true})
	return saves

# === PRIVATE SAVE METHODS ===

func _save_game_manager() -> Dictionary:
	return {
		"money": GameManager.money,
		"current_day": GameManager.current_day,
		"current_season": GameManager.current_season,
		"game_time": GameManager.game_time,
		"player_name": GameManager.player_name,
		"farm_name": GameManager.farm_name
	}

func _save_inventory() -> Dictionary:
	return {
		"items": InventoryManager.items.duplicate(true)
	}

func _save_player() -> Dictionary:
	var player = get_tree().get_first_node_in_group("player")
	if not player:
		return {}

	return {
		"position": var_to_str(player.global_position),
		"rotation": var_to_str(player.global_rotation),
		"current_tool": player.current_tool if "current_tool" in player else "hoe"
	}

func _save_farm_plots() -> Dictionary:
	var plots_data = []
	var plots = get_tree().get_nodes_in_group("farm_plots")

	for plot in plots:
		if plot is FarmPlot:
			plots_data.append({
				"position": var_to_str(plot.global_position),
				"state": plot.current_state,
				"planted_crop_id": plot.planted_crop_id,
				"growth_progress": plot.growth_progress,
				"current_stage": plot.current_stage,
				"last_watered_day": plot.last_watered_day,
				"is_watered_today": plot.is_watered_today
			})

	return {"plots": plots_data}

func _save_buildings() -> Array:
	var buildings_data = []
	var buildings = get_tree().get_nodes_in_group("buildings")

	for building in buildings:
		if building is Building:
			buildings_data.append({
				"position": var_to_str(building.global_position),
				"type": building.building_type,
				"level": building.building_level,
				"unlocked": building.is_unlocked
			})

	return buildings_data

func _save_animals() -> Array:
	var animals_data = []
	var animals = get_tree().get_nodes_in_group("animals")

	for animal in animals:
		if animal is Animal:
			animals_data.append({
				"position": var_to_str(animal.global_position),
				"type": animal.animal_type,
				"name": animal.animal_name,
				"happiness": animal.happiness,
				"hunger": animal.hunger,
				"cleanliness": animal.cleanliness,
				"product_ready": animal.product_ready,
				"days_since_last_collection": animal.days_since_last_collection
			})

	return animals_data

func _save_weather() -> Dictionary:
	return {
		"current_weather": WeatherSystem.current_weather,
		"is_raining": WeatherSystem.is_raining
	}

# === PRIVATE LOAD METHODS ===

func _load_game_manager(data: Dictionary) -> void:
	GameManager.money = data.get("money", 1000)
	GameManager.current_day = data.get("current_day", 1)
	GameManager.current_season = data.get("current_season", "spring")
	GameManager.game_time = data.get("game_time", 6.0)
	GameManager.player_name = data.get("player_name", "Người chơi")
	GameManager.farm_name = data.get("farm_name", "Nông trại mơ ước")

func _load_inventory(data: Dictionary) -> void:
	InventoryManager.items = data.get("items", {}).duplicate(true)
	InventoryManager.inventory_changed.emit()

func _load_player(data: Dictionary) -> void:
	var player = get_tree().get_first_node_in_group("player")
	if not player:
		return

	if data.has("position"):
		player.global_position = str_to_var(data["position"])
	if data.has("rotation"):
		player.global_rotation = str_to_var(data["rotation"])
	if data.has("current_tool"):
		player.current_tool = data["current_tool"]

func _load_farm_plots(data: Dictionary) -> void:
	var plots = get_tree().get_nodes_in_group("farm_plots")
	var plots_data = data.get("plots", [])

	# Match saved data to existing plots by position
	for i in min(plots.size(), plots_data.size()):
		var plot = plots[i]
		var plot_data = plots_data[i]

		if plot is FarmPlot:
			plot.current_state = plot_data.get("state", FarmPlot.State.EMPTY)
			plot.planted_crop_id = plot_data.get("planted_crop_id", "")
			plot.growth_progress = plot_data.get("growth_progress", 0.0)
			plot.current_stage = plot_data.get("current_stage", 0)
			plot.last_watered_day = plot_data.get("last_watered_day", -1)
			plot.is_watered_today = plot_data.get("is_watered_today", false)

func _load_buildings(data: Array) -> void:
	var buildings = get_tree().get_nodes_in_group("buildings")

	for i in min(buildings.size(), data.size()):
		var building = buildings[i]
		var building_data = data[i]

		if building is Building:
			building.building_level = building_data.get("level", 1)
			building.is_unlocked = building_data.get("unlocked", false)

func _load_animals(data: Array) -> void:
	var animals = get_tree().get_nodes_in_group("animals")

	for i in min(animals.size(), data.size()):
		var animal = animals[i]
		var animal_data = data[i]

		if animal is Animal:
			animal.animal_name = animal_data.get("name", "")
			animal.happiness = animal_data.get("happiness", 100.0)
			animal.hunger = animal_data.get("hunger", 0.0)
			animal.cleanliness = animal_data.get("cleanliness", 100.0)
			animal.product_ready = animal_data.get("product_ready", false)
			animal.days_since_last_collection = animal_data.get("days_since_last_collection", 0)

func _load_weather(data: Dictionary) -> void:
	WeatherSystem.current_weather = data.get("current_weather", WeatherSystem.Weather.SUNNY)
	WeatherSystem.is_raining = data.get("is_raining", false)

# === UTILITY METHODS ===

func _save_data_to_dict(save_data: SaveData) -> Dictionary:
	return {
		"version": save_data.version,
		"timestamp": save_data.timestamp,
		"playtime": save_data.playtime,
		"screenshot": save_data.screenshot,
		"player_data": save_data.player_data,
		"farm_data": save_data.farm_data,
		"inventory_data": save_data.inventory_data,
		"buildings_data": save_data.buildings_data,
		"animals_data": save_data.animals_data,
		"game_manager_data": save_data.game_manager_data,
		"weather_data": save_data.weather_data
	}

func _get_playtime() -> float:
	# Should track this in GameManager
	return Time.get_ticks_msec() / 1000.0

func _capture_screenshot() -> String:
	# Capture viewport as image from root
	var viewport = get_tree().root.get_viewport()
	if not viewport:
		return ""

	var img = viewport.get_texture().get_image()
	if not img:
		return ""

	# Resize to thumbnail
	img.resize(320, 180, Image.INTERPOLATE_LANCZOS)

	# Convert to PNG bytes
	var png_bytes = img.save_png_to_buffer()
	if not png_bytes:
		return ""

	# Encode to base64
	return Marshalls.raw_to_base64(png_bytes)

## Auto-save
func auto_save() -> void:
	print("💾 Auto-saving...")
	await save_game(0)  # Always auto-save to slot 0

## Quick save (F5)
func quick_save() -> void:
	var success = await save_game(0)
	if success:
		_show_notification("💾 Quick saved!", Color(0.5, 1, 0.5))

## Quick load (F9)
func quick_load() -> void:
	if load_game(0):
		_show_notification("📂 Quick loaded!", Color(0.5, 0.8, 1))
	else:
		print("⚠️ No quick save found")

## Helper to show notification
func _show_notification(text: String, color: Color) -> void:
	# Try to find HUD in scene tree
	var hud = get_tree().get_first_node_in_group("hud")
	if hud and hud.has_method("show_notification"):
		hud.show_notification(text, color)
	else:
		print(text)
