extends Node
## PerformanceMonitor - Monitor và tối ưu hiệu suất game

signal fps_changed(fps: int)
signal performance_warning(message: String)

# Performance metrics
var current_fps: int = 60
var target_fps: int = 60
var frame_time: float = 0.0
var draw_calls: int = 0

# Optimization flags
var low_performance_mode: bool = false
var auto_optimize: bool = true

# Thresholds
const FPS_WARNING_THRESHOLD = 30
const FPS_CRITICAL_THRESHOLD = 20

# Update interval
var monitor_interval: float = 0.5
var time_since_update: float = 0.0

func _ready() -> void:
	print("📊 Performance Monitor khởi động!")
	_detect_performance_tier()

func _process(delta: float) -> void:
	time_since_update += delta

	if time_since_update >= monitor_interval:
		_update_metrics()
		time_since_update = 0.0

func _update_metrics() -> void:
	# Get FPS
	var new_fps = Engine.get_frames_per_second()
	if new_fps != current_fps:
		current_fps = new_fps
		fps_changed.emit(current_fps)

	# Check for performance issues
	if auto_optimize:
		_check_performance()

func _check_performance() -> void:
	if current_fps < FPS_CRITICAL_THRESHOLD and not low_performance_mode:
		enable_low_performance_mode()
		performance_warning.emit("FPS rất thấp! Đã bật chế độ hiệu suất cao.")
	elif current_fps < FPS_WARNING_THRESHOLD:
		performance_warning.emit("FPS thấp! Cân nhắc giảm cài đặt đồ họa.")

func _detect_performance_tier() -> void:
	# Detect device performance tier
	var render_info = RenderingServer.get_rendering_info(RenderingServer.RENDERING_INFO_TOTAL_OBJECTS_IN_FRAME)

	# Simple tier detection (can be enhanced)
	if OS.get_processor_count() < 4:
		print("📊 Detected: Low-end device")
		enable_low_performance_mode()
	else:
		print("📊 Detected: Mid/High-end device")

## Enable low performance mode
func enable_low_performance_mode() -> void:
	if low_performance_mode:
		return

	low_performance_mode = true
	print("⚡ Enabling low performance mode...")

	# Reduce graphics quality
	var viewport = get_viewport()
	if viewport:
		# Reduce MSAA
		viewport.msaa_3d = Viewport.MSAA_DISABLED

	# Disable shadows globally
	var light = get_tree().root.find_child("DirectionalLight3D", true, false)
	if light and light is DirectionalLight3D:
		light.shadow_enabled = false

	# Reduce particle count (would need to iterate through all particle systems)
	_reduce_particle_quality()

	print("✅ Low performance mode enabled")

## Disable low performance mode
func disable_low_performance_mode() -> void:
	if not low_performance_mode:
		return

	low_performance_mode = false
	print("⚡ Disabling low performance mode...")

	# Restore graphics quality
	var viewport = get_viewport()
	if viewport:
		viewport.msaa_3d = Viewport.MSAA_2X

	var light = get_tree().root.find_child("DirectionalLight3D", true, false)
	if light and light is DirectionalLight3D:
		light.shadow_enabled = true

	print("✅ Normal performance mode restored")

func _reduce_particle_quality() -> void:
	# Reduce particle amounts for all active particles
	var particles = get_tree().get_nodes_in_group("particles")
	for particle in particles:
		if particle is GPUParticles3D:
			particle.amount = max(1, int(particle.amount * 0.5))

## Get performance report
func get_performance_report() -> Dictionary:
	return {
		"fps": current_fps,
		"target_fps": target_fps,
		"low_performance_mode": low_performance_mode,
		"memory_used": OS.get_static_memory_usage(),
		"objects_in_frame": RenderingServer.get_rendering_info(RenderingServer.RENDERING_INFO_TOTAL_OBJECTS_IN_FRAME)
	}

## Set target FPS
func set_target_fps(fps: int) -> void:
	target_fps = fps
	Engine.max_fps = fps

## Enable/disable vsync
func set_vsync(enabled: bool) -> void:
	if enabled:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
