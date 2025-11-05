extends Node3D
class_name Building
## Công trình xây dựng trong nông trại

signal building_upgraded(new_level: int)
signal building_interacted()

enum BuildingType {
	WAREHOUSE,      # Nhà kho (tăng dung lượng kho)
	BARN,          # Chuồng trại (chứa động vật)
	MILL,          # Cối xay (chế biến lúa mì thành bột)
	WORKSHOP,      # Xưởng chế biến (chế biến sản phẩm)
	SILO,          # Kho thóc (lưu trữ thức ăn)
	COOP,          # Chuồng gà
	BEEHOUSE       # Nhà ong
}

@export var building_type: BuildingType = BuildingType.WAREHOUSE
@export var building_level: int = 1:
	set(value):
		building_level = value
		_update_visual()
		building_upgraded.emit(building_level)

var is_unlocked: bool = false
var mesh_instance: MeshInstance3D
var label_3d: Label3D

const BUILDING_DATA = {
	BuildingType.WAREHOUSE: {
		"name_vi": "Nhà kho",
		"description": "Tăng dung lượng kho đồ",
		"base_cost": 500,
		"upgrade_cost_multiplier": 2.0,
		"color": Color(0.6, 0.5, 0.4),
		"size": Vector3(3, 2.5, 3),
		"capacity_bonus": 20  # +20 slots per level
	},
	BuildingType.BARN: {
		"name_vi": "Chuồng trại",
		"description": "Chứa bò và cừu",
		"base_cost": 800,
		"upgrade_cost_multiplier": 2.0,
		"color": Color(0.7, 0.3, 0.2),
		"size": Vector3(4, 3, 4),
		"animal_capacity": 4  # animals per level
	},
	BuildingType.MILL: {
		"name_vi": "Cối xay",
		"description": "Xay lúa mì thành bột",
		"base_cost": 1000,
		"upgrade_cost_multiplier": 1.8,
		"color": Color(0.8, 0.7, 0.6),
		"size": Vector3(2.5, 4, 2.5),
		"process_speed": 1.0  # items per hour
	},
	BuildingType.WORKSHOP: {
		"name_vi": "Xưởng chế biến",
		"description": "Chế biến sản phẩm nông nghiệp",
		"base_cost": 1200,
		"upgrade_cost_multiplier": 2.0,
		"color": Color(0.5, 0.5, 0.6),
		"size": Vector3(3.5, 2.8, 3),
		"recipes_unlocked": 2  # recipes per level
	},
	BuildingType.SILO: {
		"name_vi": "Kho thóc",
		"description": "Lưu trữ thức ăn chăn nuôi",
		"base_cost": 400,
		"upgrade_cost_multiplier": 1.5,
		"color": Color(0.7, 0.7, 0.7),
		"size": Vector3(2, 3.5, 2),
		"feed_capacity": 100  # feed storage per level
	},
	BuildingType.COOP: {
		"name_vi": "Chuồng gà",
		"description": "Chứa gà đẻ trứng",
		"base_cost": 300,
		"upgrade_cost_multiplier": 1.8,
		"color": Color(0.8, 0.6, 0.3),
		"size": Vector3(2.5, 2, 2.5),
		"animal_capacity": 6  # chickens per level
	},
	BuildingType.BEEHOUSE: {
		"name_vi": "Nhà ong",
		"description": "Nuôi ong lấy mật",
		"base_cost": 600,
		"upgrade_cost_multiplier": 1.5,
		"color": Color(0.9, 0.8, 0.3),
		"size": Vector3(1.5, 1.5, 1.5),
		"hive_capacity": 3  # hives per level
	}
}

func _ready() -> void:
	_setup_visuals()
	_update_visual()

func _setup_visuals() -> void:
	var data = BUILDING_DATA[building_type]

	# Create building mesh
	mesh_instance = MeshInstance3D.new()
	var box = BoxMesh.new()
	box.size = data["size"]
	mesh_instance.mesh = box

	var material = StandardMaterial3D.new()
	material.albedo_color = data["color"]
	mesh_instance.material_override = material
	mesh_instance.position.y = data["size"].y / 2.0
	add_child(mesh_instance)

	# Add label
	label_3d = Label3D.new()
	label_3d.text = data["name_vi"]
	label_3d.pixel_size = 0.008
	label_3d.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	label_3d.position = Vector3(0, data["size"].y + 0.5, 0)
	add_child(label_3d)

	# Add collision for interaction
	var collision = CollisionShape3D.new()
	var shape = BoxShape3D.new()
	shape.size = data["size"]
	collision.shape = shape
	collision.position.y = data["size"].y / 2.0

	if not has_node("StaticBody3D"):
		var static_body = StaticBody3D.new()
		static_body.name = "StaticBody3D"
		static_body.collision_layer = 16  # Buildings layer
		add_child(static_body)
		static_body.add_child(collision)

func _update_visual() -> void:
	if not label_3d:
		return

	var data = BUILDING_DATA[building_type]
	label_3d.text = data["name_vi"] + " (Lv." + str(building_level) + ")"

	# Make it brighter with higher level
	if mesh_instance and is_unlocked:
		var brightness = 1.0 + (building_level * 0.1)
		mesh_instance.material_override.albedo_color = data["color"].lightened(brightness * 0.1)

func get_building_name() -> String:
	return BUILDING_DATA[building_type]["name_vi"]

func get_description() -> String:
	return BUILDING_DATA[building_type]["description"]

func get_upgrade_cost() -> int:
	var data = BUILDING_DATA[building_type]
	return int(data["base_cost"] * pow(data["upgrade_cost_multiplier"], building_level - 1))

func can_upgrade() -> bool:
	return GameManager.money >= get_upgrade_cost()

func upgrade() -> bool:
	if not can_upgrade():
		print("❌ Không đủ tiền để nâng cấp ", get_building_name())
		return false

	var cost = get_upgrade_cost()
	if GameManager.spend_money(cost):
		building_level += 1
		print("⬆️ Đã nâng cấp ", get_building_name(), " lên Lv.", building_level)
		return true

	return false

func interact() -> void:
	building_interacted.emit()
	print("🏗️ Tương tác với ", get_building_name())

	# Building-specific interactions
	match building_type:
		BuildingType.MILL:
			_process_at_mill()
		BuildingType.WORKSHOP:
			_open_workshop()

func _process_at_mill() -> void:
	# Convert wheat to flour
	if InventoryManager.has_item("wheat", 1):
		InventoryManager.remove_item("wheat", 1)
		InventoryManager.add_item("flour", 1)
		print("🌾 Đã xay 1 lúa mì thành bột!")
	else:
		print("❌ Không có lúa mì để xay!")

func _open_workshop() -> void:
	print("🔨 Mở xưởng chế biến...")
	# This would open a crafting UI

func get_info() -> String:
	var data = BUILDING_DATA[building_type]
	var info = "%s (Cấp %d)\n%s\nNâng cấp: %d xu" % [
		data["name_vi"],
		building_level,
		data["description"],
		get_upgrade_cost()
	]

	# Add building-specific info
	match building_type:
		BuildingType.WAREHOUSE:
			info += "\nDung lượng thêm: +" + str(data["capacity_bonus"] * building_level)
		BuildingType.BARN, BuildingType.COOP:
			info += "\nChứa được: " + str(data["animal_capacity"] * building_level) + " con"
		BuildingType.SILO:
			info += "\nLưu trữ: " + str(data["feed_capacity"] * building_level) + " thức ăn"

	return info
