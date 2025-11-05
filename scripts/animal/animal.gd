extends Node3D
class_name Animal
## Một con vật trong nông trại

signal animal_fed()
signal animal_cleaned()
signal product_collected(product_id: String, amount: int)
signal happiness_changed(new_happiness: float)
signal state_changed(new_state: String)

enum AnimalType { CHICKEN, COW, SHEEP, BEE }
enum State { HAPPY, HUNGRY, DIRTY, SICK }

# Animal properties
@export var animal_type: AnimalType = AnimalType.CHICKEN
@export var animal_name: String = ""

# Stats
var happiness: float = 100.0:
	set(value):
		happiness = clampf(value, 0.0, 100.0)
		happiness_changed.emit(happiness)

var hunger: float = 0.0  # 0 = full, 100 = starving
var cleanliness: float = 100.0  # 0 = very dirty, 100 = clean
var current_state: State = State.HAPPY

# Product tracking
var product_ready: bool = false
var days_since_last_collection: int = 0
var last_fed_day: int = -1
var last_cleaned_day: int = -1

# Visual
var mesh_instance: MeshInstance3D
var label_3d: Label3D

# Animal type data
const ANIMAL_DATA = {
	AnimalType.CHICKEN: {
		"name_vi": "Gà",
		"product_id": "egg",
		"product_name": "Trứng",
		"days_for_product": 1,
		"min_product": 1,
		"max_product": 2,
		"hunger_per_day": 25.0,
		"dirty_per_day": 15.0,
		"color": Color(0.9, 0.9, 0.8),
		"size": Vector3(0.4, 0.5, 0.4)
	},
	AnimalType.COW: {
		"name_vi": "Bò",
		"product_id": "milk",
		"product_name": "Sữa",
		"days_for_product": 1,
		"min_product": 1,
		"max_product": 1,
		"hunger_per_day": 30.0,
		"dirty_per_day": 20.0,
		"color": Color(0.8, 0.7, 0.6),
		"size": Vector3(1.2, 1.5, 1.2)
	},
	AnimalType.SHEEP: {
		"name_vi": "Cừu",
		"product_id": "wool",
		"product_name": "Len",
		"days_for_product": 3,
		"min_product": 1,
		"max_product": 1,
		"hunger_per_day": 20.0,
		"dirty_per_day": 25.0,
		"color": Color(0.95, 0.95, 0.9),
		"size": Vector3(0.8, 0.9, 0.8)
	},
	AnimalType.BEE: {
		"name_vi": "Ong",
		"product_id": "honey",
		"product_name": "Mật ong",
		"days_for_product": 4,
		"min_product": 1,
		"max_product": 2,
		"hunger_per_day": 5.0,
		"dirty_per_day": 5.0,
		"color": Color(0.9, 0.8, 0.2),
		"size": Vector3(0.6, 0.6, 0.6)
	}
}

func _ready() -> void:
	_setup_visuals()
	if animal_name == "":
		animal_name = get_animal_type_name()

	# Connect to game manager signals
	GameManager.day_changed.connect(_on_new_day)

func _setup_visuals() -> void:
	# Create simple mesh for animal
	mesh_instance = MeshInstance3D.new()

	var data = ANIMAL_DATA[animal_type]

	if animal_type == AnimalType.BEE:
		# Beehive box shape
		var box = BoxMesh.new()
		box.size = data["size"]
		mesh_instance.mesh = box
	else:
		# Animal body (sphere for simplicity)
		var sphere = SphereMesh.new()
		sphere.radius = data["size"].x / 2.0
		sphere.height = data["size"].y
		mesh_instance.mesh = sphere

	var material = StandardMaterial3D.new()
	material.albedo_color = data["color"]
	mesh_instance.material_override = material
	add_child(mesh_instance)

	# Add name label
	label_3d = Label3D.new()
	label_3d.text = animal_name
	label_3d.pixel_size = 0.01
	label_3d.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	label_3d.position = Vector3(0, data["size"].y + 0.3, 0)
	add_child(label_3d)

	_update_visual_state()

func _update_visual_state() -> void:
	if not mesh_instance:
		return

	# Change color based on state
	var base_color = ANIMAL_DATA[animal_type]["color"]
	match current_state:
		State.HAPPY:
			mesh_instance.material_override.albedo_color = base_color
		State.HUNGRY:
			mesh_instance.material_override.albedo_color = base_color.darkened(0.3)
		State.DIRTY:
			mesh_instance.material_override.albedo_color = Color(0.4, 0.35, 0.3)  # Brown/muddy
		State.SICK:
			mesh_instance.material_override.albedo_color = Color(0.5, 0.6, 0.5)  # Sickly green

	# Update label color
	if label_3d:
		if product_ready:
			label_3d.modulate = Color(1.0, 0.8, 0.0)  # Gold when product ready
		else:
			label_3d.modulate = Color(1.0, 1.0, 1.0)

## Feed the animal
func feed() -> bool:
	if not InventoryManager.has_item("animal_feed", 1):
		print("❌ Không có thức ăn chăn nuôi!")
		return false

	if last_fed_day == GameManager.current_day:
		print("🍖 ", animal_name, " đã được cho ăn hôm nay!")
		return false

	InventoryManager.remove_item("animal_feed", 1)
	hunger = maxf(0.0, hunger - 50.0)
	happiness = minf(100.0, happiness + 10.0)
	last_fed_day = GameManager.current_day

	_update_state()
	animal_fed.emit()
	print("🍖 Đã cho ", animal_name, " ăn")
	return true

## Clean the animal/pen
func clean() -> bool:
	if last_cleaned_day == GameManager.current_day:
		print("🧹 ", animal_name, " đã được vệ sinh hôm nay!")
		return false

	cleanliness = 100.0
	happiness = minf(100.0, happiness + 5.0)
	last_cleaned_day = GameManager.current_day

	_update_state()
	animal_cleaned.emit()
	print("🧹 Đã vệ sinh ", animal_name)
	return true

## Collect product
func collect_product() -> bool:
	if not product_ready:
		var data = ANIMAL_DATA[animal_type]
		print("❌ ", animal_name, " chưa có ", data["product_name"], "!")
		return false

	var data = ANIMAL_DATA[animal_type]
	var amount = randi_range(data["min_product"], data["max_product"])

	# Quality based on happiness
	if happiness < 50:
		amount = maxi(1, amount - 1)

	InventoryManager.add_item(data["product_id"], amount)

	product_ready = false
	days_since_last_collection = 0
	happiness = minf(100.0, happiness + 5.0)

	product_collected.emit(data["product_id"], amount)
	print("📦 Thu được ", amount, " ", data["product_name"], " từ ", animal_name)
	return true

## Update state based on needs
func _update_state() -> void:
	var old_state = current_state

	if hunger > 75:
		current_state = State.HUNGRY
	elif cleanliness < 30:
		current_state = State.DIRTY
	elif happiness < 30:
		current_state = State.SICK
	else:
		current_state = State.HAPPY

	if old_state != current_state:
		state_changed.emit(get_state_name())
		_update_visual_state()

## Get state name in Vietnamese
func get_state_name() -> String:
	match current_state:
		State.HAPPY:
			return "Vui vẻ"
		State.HUNGRY:
			return "Đói"
		State.DIRTY:
			return "Bẩn"
		State.SICK:
			return "Ốm"
	return "Unknown"

## Get animal type name in Vietnamese
func get_animal_type_name() -> String:
	return ANIMAL_DATA[animal_type]["name_vi"]

## Called when new day starts
func _on_new_day(day: int) -> void:
	var data = ANIMAL_DATA[animal_type]

	# Increase hunger and dirtiness
	hunger += data["hunger_per_day"]
	cleanliness -= data["dirty_per_day"]

	# Decrease happiness if not cared for
	if hunger > 50:
		happiness -= 5.0
	if cleanliness < 50:
		happiness -= 5.0

	# Check product production
	if current_state == State.HAPPY or current_state == State.HUNGRY:
		days_since_last_collection += 1
		if days_since_last_collection >= data["days_for_product"]:
			product_ready = true
			print("✨ ", animal_name, " đã có ", data["product_name"], "!")

	_update_state()
	_update_visual_state()
	print("🐾 ", animal_name, ": Đói=", int(hunger), " Sạch=", int(cleanliness), " Vui=", int(happiness))

## Get info string
func get_info() -> String:
	var data = ANIMAL_DATA[animal_type]
	return "%s (%s)\nTrạng thái: %s\nĐói: %d%% | Sạch: %d%% | Vui: %d%%\nSản phẩm: %s" % [
		animal_name,
		data["name_vi"],
		get_state_name(),
		int(hunger),
		int(cleanliness),
		int(happiness),
		"Có" if product_ready else "Chưa"
	]
