extends Camera3D
class_name ImprovedCamera
## Camera nâng cao với smooth movement, zoom, và effects

@export var target: Node3D  # Player hoặc target to follow
@export var follow_speed: float = 5.0
@export var rotation_speed: float = 3.0

# Zoom settings
@export var min_zoom: float = 5.0
@export var max_zoom: float = 20.0
@export var zoom_speed: float = 2.0
var current_zoom: float = 10.0

# Rotation
var rotation_angle: float = 0.0
var tilt_angle: float = -35.0

# Shake effect
var shake_strength: float = 0.0
var shake_decay: float = 5.0
var shake_offset: Vector3 = Vector3.ZERO

# Smooth follow offset
var desired_offset: Vector3 = Vector3(0, 8, 10)
var current_offset: Vector3 = Vector3(0, 8, 10)

func _ready() -> void:
	if not target:
		# Find player
		target = get_tree().get_first_node_in_group("player")

func _process(delta: float) -> void:
	if not target:
		return

	_handle_zoom(delta)
	_handle_rotation(delta)
	_follow_target(delta)
	_apply_shake(delta)

func _handle_zoom(delta: float) -> void:
	# Mouse wheel zoom
	var zoom_input = Input.get_axis("zoom_out", "zoom_in")

	if Input.is_action_just_released("ui_page_down"):
		zoom_input = 1.0
	elif Input.is_action_just_released("ui_page_up"):
		zoom_input = -1.0

	if abs(zoom_input) > 0.01:
		current_zoom = clampf(current_zoom - zoom_input * zoom_speed, min_zoom, max_zoom)

	# Smoothly adjust camera distance
	var zoom_factor = current_zoom / 10.0  # Normalize
	desired_offset.z = 10.0 * zoom_factor
	desired_offset.y = 8.0 * zoom_factor

func _handle_rotation(delta: float) -> void:
	# Rotate camera around target with Q/E
	if Input.is_action_pressed("ui_focus_prev"):  # Q
		rotation_angle += rotation_speed * delta
	if Input.is_action_pressed("ui_focus_next"):  # E
		rotation_angle -= rotation_speed * delta

	# Can also use middle mouse button drag (future enhancement)

func _follow_target(delta: float) -> void:
	# Smoothly interpolate offset
	current_offset = current_offset.lerp(desired_offset, follow_speed * delta)

	# Calculate rotated offset
	var rotated_offset = current_offset.rotated(Vector3.UP, rotation_angle)

	# Calculate desired position
	var desired_position = target.global_position + rotated_offset

	# Smooth follow
	global_position = global_position.lerp(desired_position, follow_speed * delta)

	# Look at target (with tilt)
	var look_target = target.global_position + Vector3.UP
	look_at(look_target, Vector3.UP)

	# Apply tilt
	rotation_degrees.x = tilt_angle

func _apply_shake(delta: float) -> void:
	if shake_strength > 0:
		# Generate random shake offset
		shake_offset = Vector3(
			randf_range(-shake_strength, shake_strength),
			randf_range(-shake_strength, shake_strength),
			randf_range(-shake_strength, shake_strength)
		)

		# Apply shake to position
		position += shake_offset

		# Decay shake
		shake_strength = max(0, shake_strength - shake_decay * delta)
	else:
		shake_offset = Vector3.ZERO

## Trigger camera shake
func shake(strength: float, duration: float = 0.0) -> void:
	shake_strength = strength

	if duration > 0:
		await get_tree().create_timer(duration).timeout
		shake_strength = 0

## Smooth pan to position
func pan_to(target_position: Vector3, duration: float = 1.0) -> void:
	var tween = create_tween()
	tween.tween_property(self, "global_position", target_position, duration)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)

## Focus on a specific target
func focus_on(focus_target: Node3D, zoom_distance: float = 10.0, duration: float = 1.0) -> void:
	var old_target = target
	target = focus_target

	var tween = create_tween()
	tween.tween_property(self, "current_zoom", zoom_distance, duration)

	await tween.finished

	# Restore original target if needed
	if old_target and old_target != focus_target:
		await get_tree().create_timer(2.0).timeout
		target = old_target
