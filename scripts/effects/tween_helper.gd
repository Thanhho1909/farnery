extends Node
class_name TweenHelper
## Helper functions for creating smooth animations and transitions

## Bounce an object up and down
static func bounce(node: Node3D, height: float = 0.3, duration: float = 0.5) -> Tween:
	var tween = node.create_tween()
	var start_pos = node.position

	tween.tween_property(node, "position:y", start_pos.y + height, duration * 0.3)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(node, "position:y", start_pos.y, duration * 0.7)\
		.set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)

	return tween

## Scale popup effect
static func popup(node: Node, target_scale: Vector3 = Vector3.ONE, duration: float = 0.3) -> Tween:
	var tween = node.create_tween()

	node.scale = Vector3.ZERO
	tween.tween_property(node, "scale", target_scale, duration)\
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	return tween

## Shake effect for feedback
static func shake(node: Node3D, strength: float = 0.1, duration: float = 0.3, frequency: int = 10) -> Tween:
	var tween = node.create_tween()
	var original_pos = node.position

	for i in frequency:
		var offset = Vector3(
			randf_range(-strength, strength),
			randf_range(-strength, strength),
			randf_range(-strength, strength)
		)
		tween.tween_property(node, "position", original_pos + offset, duration / frequency)

	tween.tween_property(node, "position", original_pos, duration / frequency)
	return tween

## Fade in
static func fade_in(node: CanvasItem, duration: float = 0.3) -> Tween:
	var tween = node.create_tween()
	node.modulate.a = 0
	tween.tween_property(node, "modulate:a", 1.0, duration)
	return tween

## Fade out
static func fade_out(node: CanvasItem, duration: float = 0.3) -> Tween:
	var tween = node.create_tween()
	tween.tween_property(node, "modulate:a", 0.0, duration)
	return tween

## Float animation (for items, effects)
static func float_cycle(node: Node3D, amplitude: float = 0.2, duration: float = 2.0) -> Tween:
	var tween = node.create_tween()
	var start_y = node.position.y

	tween.set_loops()
	tween.tween_property(node, "position:y", start_y + amplitude, duration * 0.5)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(node, "position:y", start_y, duration * 0.5)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	return tween

## Rotate continuously
static func rotate_continuous(node: Node3D, axis: Vector3 = Vector3.UP, speed: float = 1.0) -> Tween:
	var tween = node.create_tween()
	tween.set_loops()
	tween.tween_property(node, "rotation", node.rotation + axis * TAU, speed)\
		.set_trans(Tween.TRANS_LINEAR)
	return tween

## Scale pulse (for highlighting)
static func pulse(node: Node, min_scale: float = 0.9, max_scale: float = 1.1, duration: float = 1.0) -> Tween:
	var tween = node.create_tween()
	var original_scale = node.scale

	tween.set_loops()
	tween.tween_property(node, "scale", original_scale * max_scale, duration * 0.5)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(node, "scale", original_scale * min_scale, duration * 0.5)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	return tween

## Slide in from side
static func slide_in(node: Control, from_side: String = "left", duration: float = 0.3) -> Tween:
	var tween = node.create_tween()
	var viewport_size = node.get_viewport_rect().size
	var original_pos = node.position

	match from_side:
		"left":
			node.position.x = -node.size.x
		"right":
			node.position.x = viewport_size.x
		"top":
			node.position.y = -node.size.y
		"bottom":
			node.position.y = viewport_size.y

	tween.tween_property(node, "position", original_pos, duration)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

	return tween

## Color flash (for damage/heal effects)
static func flash_color(node: Node3D, color: Color = Color.WHITE, duration: float = 0.2) -> Tween:
	var tween = node.create_tween()

	# Assuming node has a mesh with material
	if node is MeshInstance3D and node.material_override:
		var original_color = node.material_override.albedo_color
		tween.tween_property(node.material_override, "albedo_color", color, duration * 0.3)
		tween.tween_property(node.material_override, "albedo_color", original_color, duration * 0.7)

	return tween

## Number popup animation
static func number_popup(label: Label3D, value: int, duration: float = 1.0) -> Tween:
	var tween = label.create_tween()

	label.text = "+" + str(value)
	label.modulate.a = 1.0

	# Move up and fade out
	tween.parallel().tween_property(label, "position:y", label.position.y + 1.0, duration)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(label, "modulate:a", 0.0, duration)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)

	# Queue free when done
	tween.tween_callback(label.queue_free)

	return tween
