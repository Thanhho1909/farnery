extends CharacterBody3D
## Player controller với movement và interaction

signal interacted_with(interactable: Interactable)

@export var move_speed: float = 5.0
@export var rotation_speed: float = 10.0
@export var interaction_raycast_distance: float = 3.0

var current_tool: String = "hoe"  # hoe, watering_can, axe, etc
var interaction_raycast: RayCast3D
var camera: Camera3D
var mesh_instance: MeshInstance3D

# Nearby interactables
var nearby_interactables: Array[Interactable] = []
var current_interactable: Interactable = null

func _ready() -> void:
	add_to_group("player")
	_setup_player_visuals()
	_setup_camera()
	_setup_raycast()

func _setup_player_visuals() -> void:
	# Get mesh from scene, or create if doesn't exist
	mesh_instance = get_node_or_null("MeshInstance3D")
	if not mesh_instance:
		mesh_instance = MeshInstance3D.new()
		var capsule = CapsuleMesh.new()
		capsule.radius = 0.3
		capsule.height = 1.6
		mesh_instance.mesh = capsule

		var material = StandardMaterial3D.new()
		material.albedo_color = Color(0.3, 0.6, 0.9)  # Blue player
		mesh_instance.material_override = material
		mesh_instance.position.y = 0.8
		add_child(mesh_instance)

	# Add collision if doesn't exist
	if not get_node_or_null("CollisionShape3D"):
		var collision = CollisionShape3D.new()
		var shape = CapsuleShape3D.new()
		shape.radius = 0.3
		shape.height = 1.6
		collision.shape = shape
		collision.position.y = 0.8
		add_child(collision)

	# Set collision layers
	collision_layer = 2  # Player layer
	collision_mask = 1 | 16  # Ground and buildings

func _setup_camera() -> void:
	# Get camera from scene, or create if doesn't exist
	var camera_pivot = get_node_or_null("CameraPivot")
	if not camera_pivot:
		camera_pivot = Node3D.new()
		camera_pivot.name = "CameraPivot"
		add_child(camera_pivot)

	camera = camera_pivot.get_node_or_null("Camera3D")
	if not camera:
		camera = Camera3D.new()
		camera.position = Vector3(0, 8, 10)
		camera.rotation_degrees = Vector3(-35, 0, 0)
		camera_pivot.add_child(camera)

func _setup_raycast() -> void:
	# Get raycast from scene, or create if doesn't exist
	interaction_raycast = get_node_or_null("RayCast3D")
	if not interaction_raycast:
		interaction_raycast = RayCast3D.new()
		interaction_raycast.target_position = Vector3(0, -1, -interaction_raycast_distance)
		interaction_raycast.collision_mask = 1 | 8 | 16 | 32  # Ground, crops, animals, buildings
		add_child(interaction_raycast)

func _physics_process(delta: float) -> void:
	_handle_movement(delta)
	_check_nearby_interactable()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		_try_interact()

	# Tool switching (1-5 keys)
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_1:
				switch_tool("hoe")
			KEY_2:
				switch_tool("watering_can")
			KEY_3:
				switch_tool("axe")

func _handle_movement(delta: float) -> void:
	var input_dir = Vector2.ZERO
	input_dir.x = Input.get_axis("move_left", "move_right")
	input_dir.y = Input.get_axis("move_forward", "move_backward")

	if input_dir.length() > 0:
		input_dir = input_dir.normalized()

		# Calculate movement direction
		var move_direction = Vector3(input_dir.x, 0, input_dir.y)

		# Move
		velocity.x = move_direction.x * move_speed
		velocity.z = move_direction.z * move_speed

		# Rotate towards movement direction
		if move_direction.length() > 0.1:
			var target_rotation = atan2(move_direction.x, move_direction.z)
			rotation.y = lerp_angle(rotation.y, target_rotation, rotation_speed * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, move_speed)
		velocity.z = move_toward(velocity.z, 0, move_speed)

	# Apply gravity
	if not is_on_floor():
		velocity.y -= 20.0 * delta
	else:
		velocity.y = 0

	move_and_slide()

func _check_nearby_interactable() -> void:
	# Update raycast
	interaction_raycast.force_raycast_update()

	if interaction_raycast.is_colliding():
		var collider = interaction_raycast.get_collider()
		if collider:
			# Check if parent has interactable
			var interactable = _find_interactable_in_parents(collider)
			if interactable and interactable != current_interactable:
				current_interactable = interactable

func _find_interactable_in_parents(node: Node) -> Interactable:
	var current = node
	while current:
		if current is Interactable:
			return current
		# Check if has Interactable as child
		for child in current.get_children():
			if child is Interactable:
				return child
		current = current.get_parent()
	return null

func _try_interact() -> void:
	# First check for nearby Area3D interactables
	var closest_interactable: Interactable = null
	var closest_distance: float = INF

	for interactable in nearby_interactables:
		if not is_instance_valid(interactable):
			continue

		var distance = global_position.distance_to(interactable.global_position)
		if distance < closest_distance and distance < interaction_raycast_distance:
			closest_distance = distance
			closest_interactable = interactable

	if closest_interactable:
		_interact_with(closest_interactable)
		return

	# Then check raycast for direct interactions
	interaction_raycast.force_raycast_update()
	if interaction_raycast.is_colliding():
		var collider = interaction_raycast.get_collider()
		_handle_direct_interaction(collider)

func _interact_with(interactable: Interactable) -> void:
	interactable.interact(self)
	interacted_with.emit(interactable)

func _handle_direct_interaction(collider: Node) -> void:
	if not collider:
		return

	# Check parent for specific types
	var parent = collider.get_parent()

	if parent is FarmPlot:
		_interact_with_farm_plot(parent)
	elif parent is Animal:
		_interact_with_animal(parent)
	elif parent is Building:
		_interact_with_building(parent)

func _interact_with_farm_plot(plot: FarmPlot) -> void:
	match current_tool:
		"hoe":
			if plot.current_state == FarmPlot.State.EMPTY:
				plot.till()
			elif plot.current_state == FarmPlot.State.TILLED:
				# Try to plant (would show seed selection UI)
				_try_plant_on_plot(plot)
			elif plot.current_state == FarmPlot.State.HARVESTABLE:
				plot.harvest()

		"watering_can":
			if plot.current_state in [FarmPlot.State.PLANTED, FarmPlot.State.GROWING]:
				plot.water()

func _try_plant_on_plot(plot: FarmPlot) -> void:
	# Try to plant first available seed
	var seeds = ["seed_carrot", "seed_wheat", "seed_tomato", "seed_corn", "seed_potato"]
	for seed_id in seeds:
		if InventoryManager.has_item(seed_id, 1):
			# Get crop id from seed (remove "seed_" prefix)
			var crop_id = seed_id.replace("seed_", "")
			if plot.plant_crop(crop_id):
				return
	print("❌ Không có hạt giống để trồng!")

func _interact_with_animal(animal: Animal) -> void:
	print("🐾 Tương tác với ", animal.animal_name)
	# This would open an animal care menu
	# For now, try to feed or collect product

	if animal.product_ready:
		animal.collect_product()
	elif animal.hunger > 50:
		animal.feed()
	elif animal.cleanliness < 50:
		animal.clean()
	else:
		print("ℹ️ ", animal.get_info())

func _interact_with_building(building: Building) -> void:
	print("🏗️ Tương tác với ", building.get_building_name())
	building.interact()

func switch_tool(tool_name: String) -> void:
	if InventoryManager.has_item(tool_name, 1):
		current_tool = tool_name
		print("🔧 Chuyển sang công cụ: ", tool_name)
	else:
		print("❌ Không có công cụ: ", tool_name)

## Register interactable in range
func register_interactable(interactable: Interactable) -> void:
	if not interactable in nearby_interactables:
		nearby_interactables.append(interactable)

## Unregister interactable out of range
func unregister_interactable(interactable: Interactable) -> void:
	nearby_interactables.erase(interactable)
