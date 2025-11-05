extends CharacterBody3D
class_name NPC
## NPC thân thiện trong game

signal dialogue_started(npc: NPC)
signal dialogue_ended(npc: NPC)
signal quest_given(quest_id: String)

enum NPCType { SHOPKEEPER, VILLAGER, QUEST_GIVER }

@export var npc_type: NPCType = NPCType.VILLAGER
@export var npc_name: String = "Người dân"
@export var greeting: String = "Xin chào!"
@export var dialogues: Array[String] = []

var mesh_instance: MeshInstance3D
var label_3d: Label3D
var interactable: Interactable
var current_dialogue_index: int = 0

const NPC_COLORS = {
	NPCType.SHOPKEEPER: Color(0.8, 0.6, 0.2),  # Gold
	NPCType.VILLAGER: Color(0.5, 0.7, 0.4),     # Green
	NPCType.QUEST_GIVER: Color(0.6, 0.3, 0.8)   # Purple
}

func _ready() -> void:
	_setup_visuals()
	_setup_interactable()
	_setup_default_dialogues()

func _setup_visuals() -> void:
	# Create NPC mesh (capsule)
	mesh_instance = MeshInstance3D.new()
	var capsule = CapsuleMesh.new()
	capsule.radius = 0.3
	capsule.height = 1.6
	mesh_instance.mesh = capsule

	var material = StandardMaterial3D.new()
	material.albedo_color = NPC_COLORS.get(npc_type, Color(0.7, 0.7, 0.7))
	mesh_instance.material_override = material
	mesh_instance.position.y = 0.8
	add_child(mesh_instance)

	# Add name label
	label_3d = Label3D.new()
	label_3d.text = npc_name
	label_3d.pixel_size = 0.008
	label_3d.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	label_3d.modulate = Color(1, 1, 1)
	label_3d.outline_size = 5
	label_3d.outline_modulate = Color(0, 0, 0, 0.8)
	label_3d.position = Vector3(0, 2.2, 0)
	add_child(label_3d)

	# Add collision
	var collision = CollisionShape3D.new()
	var shape = CapsuleShape3D.new()
	shape.radius = 0.3
	shape.height = 1.6
	collision.shape = shape
	collision.position.y = 0.8
	add_child(collision)

	collision_layer = 0
	collision_mask = 0

func _setup_interactable() -> void:
	interactable = Interactable.new()
	interactable.interaction_prompt = "E để nói chuyện với " + npc_name
	interactable.interaction_distance = 2.5
	add_child(interactable)

	interactable.interacted.connect(_on_interacted)

func _setup_default_dialogues() -> void:
	if dialogues.size() == 0:
		match npc_type:
			NPCType.SHOPKEEPER:
				dialogues = [
					"Chào mừng đến cửa hàng!",
					"Tôi có nhiều hạt giống và công cụ đây!",
					"Bạn cần mua gì không?"
				]
			NPCType.VILLAGER:
				dialogues = [
					"Chào bạn! Thời tiết hôm nay đẹp nhỉ?",
					"Trang trại của bạn phát triển tốt đấy!",
					"Tôi thích sống ở đây lắm!"
				]
			NPCType.QUEST_GIVER:
				dialogues = [
					"Ồ, bạn đến đúng lúc!",
					"Tôi có việc cần nhờ bạn đây...",
					"Bạn có thể giúp tôi không?"
				]

func _on_interacted(player: Node3D) -> void:
	start_dialogue()

func start_dialogue() -> void:
	dialogue_started.emit(self)
	current_dialogue_index = 0
	show_dialogue()

func show_dialogue() -> void:
	if current_dialogue_index >= dialogues.size():
		end_dialogue()
		return

	var dialogue = dialogues[current_dialogue_index]
	print("💬 [%s]: %s" % [npc_name, dialogue])

	# In a full game, this would show UI
	# For now, just print to console

	current_dialogue_index += 1

func next_dialogue() -> void:
	show_dialogue()

func end_dialogue() -> void:
	dialogue_ended.emit(self)
	print("👋 [%s]: Hẹn gặp lại!" % npc_name)

	# Trigger NPC-specific actions
	match npc_type:
		NPCType.SHOPKEEPER:
			_open_shop()
		NPCType.QUEST_GIVER:
			_offer_quest()

func _open_shop() -> void:
	print("🏪 Mở cửa hàng...")
	# This would open shop UI
	# For now, show what's available
	print("Có sẵn:")
	print("  • Hạt giống các loại")
	print("  • Thức ăn chăn nuôi")
	print("  • Công cụ nâng cấp")

func _offer_quest() -> void:
	print("📜 Nhiệm vụ có sẵn...")
	# This would show quest UI

func get_info() -> String:
	return "%s\n%s\nLoại: %s" % [
		npc_name,
		greeting,
		_get_type_name()
	]

func _get_type_name() -> String:
	match npc_type:
		NPCType.SHOPKEEPER:
			return "Người bán hàng"
		NPCType.VILLAGER:
			return "Dân làng"
		NPCType.QUEST_GIVER:
			return "Người giao nhiệm vụ"
	return "NPC"

## Add custom dialogue
func add_dialogue(text: String) -> void:
	dialogues.append(text)

## Set dialogues
func set_dialogues(new_dialogues: Array[String]) -> void:
	dialogues = new_dialogues
