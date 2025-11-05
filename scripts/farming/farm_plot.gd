extends Node3D
class_name FarmPlot
## Một ô đất trồng trọt

signal crop_planted(crop_id: String)
signal crop_watered()
signal crop_harvested(crop_id: String, amount: int)
signal plot_state_changed()

enum State { EMPTY, TILLED, PLANTED, GROWING, HARVESTABLE, WITHERED }

# Plot state
var current_state: State = State.EMPTY:
	set(value):
		if current_state != value:
			current_state = value
			plot_state_changed.emit()
			_update_visual()

# Crop info
var planted_crop_id: String = ""
var growth_progress: float = 0.0  # 0.0 to 1.0
var current_stage: int = 0
var last_watered_day: int = -1
var is_watered_today: bool = false
var times_watered: int = 0

# References
var plot_mesh: MeshInstance3D
var crop_mesh: MeshInstance3D

# Static crop database
static var CROPS: Dictionary = {}

func _ready() -> void:
	add_to_group("farm_plots")
	_setup_visuals()
	_initialize_crop_database()

## Initialize crop database (call once)
static func _initialize_crop_database() -> void:
	if CROPS.size() > 0:
		return

	# Carrot
	var carrot = CropData.new()
	carrot.crop_id = "carrot"
	carrot.crop_name = "Cà rốt"
	carrot.seed_id = "seed_carrot"
	carrot.harvest_id = "carrot"
	carrot.growth_stages = 4
	carrot.hours_per_stage = 12.0
	carrot.valid_seasons = ["spring", "summer", "fall"]
	carrot.needs_water = true
	carrot.min_harvest = 1
	carrot.max_harvest = 3
	CROPS["carrot"] = carrot

	# Tomato
	var tomato = CropData.new()
	tomato.crop_id = "tomato"
	tomato.crop_name = "Cà chua"
	tomato.seed_id = "seed_tomato"
	tomato.harvest_id = "tomato"
	tomato.growth_stages = 5
	tomato.hours_per_stage = 16.0
	tomato.valid_seasons = ["summer", "fall"]
	tomato.can_regrow = true
	tomato.regrow_time = 24.0
	tomato.needs_water = true
	tomato.min_harvest = 2
	tomato.max_harvest = 4
	CROPS["tomato"] = tomato

	# Wheat
	var wheat = CropData.new()
	wheat.crop_id = "wheat"
	wheat.crop_name = "Lúa mì"
	wheat.seed_id = "seed_wheat"
	wheat.harvest_id = "wheat"
	wheat.growth_stages = 4
	wheat.hours_per_stage = 10.0
	wheat.valid_seasons = ["spring", "summer", "fall"]
	wheat.needs_water = true
	wheat.min_harvest = 2
	wheat.max_harvest = 5
	CROPS["wheat"] = wheat

	# Corn
	var corn = CropData.new()
	corn.crop_id = "corn"
	corn.crop_name = "Ngô"
	corn.seed_id = "seed_corn"
	corn.harvest_id = "corn"
	corn.growth_stages = 5
	corn.hours_per_stage = 14.0
	corn.valid_seasons = ["summer"]
	corn.needs_water = true
	corn.min_harvest = 1
	corn.max_harvest = 2
	CROPS["corn"] = corn

	# Potato
	var potato = CropData.new()
	potato.crop_id = "potato"
	potato.crop_name = "Khoai tây"
	potato.seed_id = "seed_potato"
	potato.harvest_id = "potato"
	potato.growth_stages = 4
	potato.hours_per_stage = 12.0
	potato.valid_seasons = ["spring", "fall", "winter"]
	potato.needs_water = true
	potato.min_harvest = 2
	potato.max_harvest = 4
	CROPS["potato"] = potato

func _setup_visuals() -> void:
	# Get plot mesh from scene, or create if doesn't exist
	plot_mesh = get_node_or_null("MeshInstance3D")
	if not plot_mesh:
		plot_mesh = MeshInstance3D.new()
		var box_mesh = BoxMesh.new()
		box_mesh.size = Vector3(1.0, 0.1, 1.0)
		plot_mesh.mesh = box_mesh

		var material = StandardMaterial3D.new()
		material.albedo_color = Color(0.4, 0.3, 0.2)  # Brown soil
		plot_mesh.material_override = material
		add_child(plot_mesh)

	# Create crop mesh (always created dynamically)
	crop_mesh = MeshInstance3D.new()
	crop_mesh.visible = false
	add_child(crop_mesh)

func _update_visual() -> void:
	match current_state:
		State.EMPTY:
			if plot_mesh:
				plot_mesh.material_override.albedo_color = Color(0.3, 0.25, 0.15)  # Dark brown
			if crop_mesh:
				crop_mesh.visible = false
		State.TILLED:
			if plot_mesh:
				plot_mesh.material_override.albedo_color = Color(0.4, 0.3, 0.2)  # Brown
			if crop_mesh:
				crop_mesh.visible = false
		State.PLANTED, State.GROWING:
			_update_crop_visual()
		State.HARVESTABLE:
			_update_crop_visual()
			# Make it brighter or add particle effect
		State.WITHERED:
			if crop_mesh:
				crop_mesh.modulate = Color(0.5, 0.4, 0.3)  # Withered color

func _update_crop_visual() -> void:
	if not crop_mesh:
		return

	crop_mesh.visible = true

	# Simple visual progression based on stage
	var scale_factor = 0.2 + (current_stage * 0.2)
	scale_factor = clampf(scale_factor, 0.2, 1.0)

	# Create a simple plant mesh if not exists
	if not crop_mesh.mesh:
		var cylinder = CylinderMesh.new()
		cylinder.top_radius = 0.1
		cylinder.bottom_radius = 0.05
		cylinder.height = 0.5
		crop_mesh.mesh = cylinder

		var mat = StandardMaterial3D.new()
		mat.albedo_color = Color(0.2, 0.8, 0.2)  # Green
		crop_mesh.material_override = mat

	crop_mesh.scale = Vector3(scale_factor, scale_factor, scale_factor)
	crop_mesh.position = Vector3(0, 0.25 * scale_factor, 0)

	# Color based on state
	if current_state == State.HARVESTABLE:
		crop_mesh.material_override.albedo_color = Color(0.8, 0.9, 0.3)  # Yellow-green (ready)
	else:
		crop_mesh.material_override.albedo_color = Color(0.2, 0.8, 0.2)  # Green (growing)

## Till the plot (cày đất)
func till() -> bool:
	if current_state != State.EMPTY:
		return false

	current_state = State.TILLED
	print("🚜 Đã cày đất tại ", position)
	return true

## Plant a crop
func plant_crop(crop_id: String) -> bool:
	if current_state != State.TILLED:
		print("❌ Cần cày đất trước!")
		return false

	if not CROPS.has(crop_id):
		push_error("Crop không tồn tại: " + crop_id)
		return false

	var crop_data: CropData = CROPS[crop_id]
	var seed_id = crop_data.seed_id

	if not InventoryManager.has_item(seed_id, 1):
		print("❌ Không có hạt giống!")
		return false

	# Check season
	if not crop_data.can_grow_in_season(GameManager.current_season):
		print("❌ Không thể trồng ", crop_data.crop_name, " trong mùa ", GameManager.get_season_name_vi())
		return false

	# Remove seed from inventory
	InventoryManager.remove_item(seed_id, 1)

	planted_crop_id = crop_id
	current_state = State.PLANTED
	current_stage = 0
	growth_progress = 0.0
	is_watered_today = false
	times_watered = 0

	crop_planted.emit(crop_id)
	print("🌱 Đã trồng ", crop_data.crop_name)
	return true

## Water the plot
func water() -> bool:
	if current_state not in [State.PLANTED, State.GROWING]:
		print("❌ Không có cây để tưới!")
		return false

	if last_watered_day == GameManager.current_day:
		print("💧 Đã tưới hôm nay rồi!")
		return false

	last_watered_day = GameManager.current_day
	is_watered_today = true
	times_watered += 1
	current_state = State.GROWING

	crop_watered.emit()
	print("💧 Đã tưới nước")
	return true

## Update growth (called by farming manager)
func update_growth(delta_hours: float) -> void:
	if current_state not in [State.PLANTED, State.GROWING]:
		return

	if not CROPS.has(planted_crop_id):
		return

	var crop_data: CropData = CROPS[planted_crop_id]

	# Check if needs water
	if crop_data.needs_water and not is_watered_today:
		# Not growing without water
		return

	# Grow
	var growth_per_hour = 1.0 / crop_data.get_total_growth_time()
	growth_progress += growth_per_hour * delta_hours

	# Update stage
	var new_stage = int(growth_progress * crop_data.growth_stages)
	if new_stage != current_stage:
		current_stage = clampi(new_stage, 0, crop_data.growth_stages - 1)
		_update_visual()

	# Check if ready to harvest
	if growth_progress >= 1.0:
		current_state = State.HARVESTABLE
		print("✨ ", crop_data.crop_name, " đã chín!")

## Harvest the crop
func harvest() -> bool:
	if current_state != State.HARVESTABLE:
		print("❌ Cây chưa chín!")
		return false

	if not CROPS.has(planted_crop_id):
		return false

	var crop_data: CropData = CROPS[planted_crop_id]
	var harvest_amount = crop_data.get_random_harvest_amount()

	# Add to inventory
	InventoryManager.add_item(crop_data.harvest_id, harvest_amount)

	crop_harvested.emit(crop_data.harvest_id, harvest_amount)
	print("🌾 Thu hoạch được ", harvest_amount, " ", crop_data.crop_name)

	# Check if can regrow
	if crop_data.can_regrow:
		growth_progress = 0.5  # Start from mid-growth
		current_stage = 0
		current_state = State.PLANTED
		is_watered_today = false
	else:
		# Reset plot
		planted_crop_id = ""
		current_state = State.EMPTY
		growth_progress = 0.0
		current_stage = 0

	return true

## Reset plot to empty
func clear_plot() -> void:
	planted_crop_id = ""
	current_state = State.EMPTY
	growth_progress = 0.0
	current_stage = 0
	is_watered_today = false
	times_watered = 0

## New day event
func on_new_day() -> void:
	is_watered_today = false

	# Check season change - wither crops not valid in new season
	if current_state in [State.PLANTED, State.GROWING] and planted_crop_id != "":
		if CROPS.has(planted_crop_id):
			var crop_data: CropData = CROPS[planted_crop_id]
			if not crop_data.can_grow_in_season(GameManager.current_season):
				current_state = State.WITHERED
				print("🍂 ", crop_data.crop_name, " đã héo do thay đổi mùa")
