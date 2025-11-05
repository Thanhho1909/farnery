extends Area3D
class_name Interactable
## Component cho các đối tượng có thể tương tác
## Hiển thị prompt "E để tương tác" khi player đến gần

signal interacted(player: Node3D)

@export var interaction_prompt: String = "Nhấn E để tương tác"
@export var interaction_enabled: bool = true
@export var interaction_distance: float = 2.0

var player_in_range: bool = false
var prompt_label: Label3D

func _ready() -> void:
	# Setup area detection
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

	# Create prompt label
	prompt_label = Label3D.new()
	prompt_label.text = interaction_prompt
	prompt_label.pixel_size = 0.01
	prompt_label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	prompt_label.modulate = Color(1, 1, 0.5)  # Yellow
	prompt_label.outline_size = 5
	prompt_label.outline_modulate = Color(0, 0, 0, 0.8)
	prompt_label.visible = false
	prompt_label.position = Vector3(0, 1.5, 0)
	add_child(prompt_label)

	# Setup collision shape if not exists
	if get_child_count() == 1:  # Only has the label
		var collision = CollisionShape3D.new()
		var shape = SphereShape3D.new()
		shape.radius = interaction_distance
		collision.shape = shape
		add_child(collision)

	collision_layer = 0
	collision_mask = 2  # Detect player layer

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_in_range = true
		if interaction_enabled:
			show_prompt()

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		hide_prompt()

func show_prompt() -> void:
	if prompt_label:
		prompt_label.visible = true

func hide_prompt() -> void:
	if prompt_label:
		prompt_label.visible = false

func set_prompt_text(text: String) -> void:
	interaction_prompt = text
	if prompt_label:
		prompt_label.text = text

func interact(player: Node3D) -> void:
	if not interaction_enabled or not player_in_range:
		return

	interacted.emit(player)
	print("🔍 Tương tác: ", interaction_prompt)

func enable_interaction() -> void:
	interaction_enabled = true
	if player_in_range:
		show_prompt()

func disable_interaction() -> void:
	interaction_enabled = false
	hide_prompt()
