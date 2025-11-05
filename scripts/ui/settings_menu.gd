extends CanvasLayer
## Settings Menu - Cài đặt đồ họa, âm thanh, điều khiển

signal settings_changed()
signal closed()

var is_open: bool = false
var panel: PanelContainer

# UI elements
var graphics_tab: VBoxContainer
var audio_tab: VBoxContainer
var controls_tab: VBoxContainer

# Settings sliders
var master_volume_slider: HSlider
var music_volume_slider: HSlider
var sfx_volume_slider: HSlider
var graphics_quality_option: OptionButton
var vsync_check: CheckBox
var fps_limit_option: OptionButton
var shadow_quality_option: OptionButton

func _ready() -> void:
	_setup_ui()
	visible = false
	set_process_input(true)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and is_open:  # ESC
		close()

func _setup_ui() -> void:
	# Main panel
	panel = PanelContainer.new()
	panel.position = Vector2(460, 140)
	panel.size = Vector2(1000, 800)
	_style_panel(panel)
	add_child(panel)

	var margin = MarginContainer.new()
	margin.add_theme_constant_override("margin_all", 20)
	panel.add_child(margin)

	var vbox_main = VBoxContainer.new()
	vbox_main.add_theme_constant_override("separation", 20)
	margin.add_child(vbox_main)

	# Title
	var title = Label.new()
	title.text = "⚙️ CÀI ĐẶT"
	title.add_theme_font_size_override("font_size", 32)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox_main.add_child(title)

	# Tab container
	var tab_container = TabContainer.new()
	tab_container.custom_minimum_size = Vector2(0, 650)
	vbox_main.add_child(tab_container)

	# Graphics tab
	graphics_tab = VBoxContainer.new()
	graphics_tab.name = "🎨 Đồ Họa"
	graphics_tab.add_theme_constant_override("separation", 15)
	tab_container.add_child(graphics_tab)
	_setup_graphics_tab()

	# Audio tab
	audio_tab = VBoxContainer.new()
	audio_tab.name = "🔊 Âm Thanh"
	audio_tab.add_theme_constant_override("separation", 15)
	tab_container.add_child(audio_tab)
	_setup_audio_tab()

	# Controls tab
	controls_tab = VBoxContainer.new()
	controls_tab.name = "🎮 Điều Khiển"
	controls_tab.add_theme_constant_override("separation", 15)
	tab_container.add_child(controls_tab)
	_setup_controls_tab()

	# Buttons
	var button_hbox = HBoxContainer.new()
	button_hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	button_hbox.add_theme_constant_override("separation", 20)
	vbox_main.add_child(button_hbox)

	var apply_button = Button.new()
	apply_button.text = "Áp Dụng"
	apply_button.custom_minimum_size = Vector2(150, 50)
	apply_button.pressed.connect(_apply_settings)
	button_hbox.add_child(apply_button)

	var close_button = Button.new()
	close_button.text = "Đóng"
	close_button.custom_minimum_size = Vector2(150, 50)
	close_button.pressed.connect(close)
	button_hbox.add_child(close_button)

func _setup_graphics_tab() -> void:
	# Graphics Quality
	var quality_label = Label.new()
	quality_label.text = "Chất Lượng Đồ Họa:"
	quality_label.add_theme_font_size_override("font_size", 20)
	graphics_tab.add_child(quality_label)

	graphics_quality_option = OptionButton.new()
	graphics_quality_option.add_item("Thấp", 0)
	graphics_quality_option.add_item("Trung Bình", 1)
	graphics_quality_option.add_item("Cao", 2)
	graphics_quality_option.add_item("Cực Cao", 3)
	graphics_quality_option.selected = 2
	graphics_tab.add_child(graphics_quality_option)

	# Shadow Quality
	var shadow_label = Label.new()
	shadow_label.text = "Chất Lượng Bóng:"
	shadow_label.add_theme_font_size_override("font_size", 20)
	graphics_tab.add_child(shadow_label)

	shadow_quality_option = OptionButton.new()
	shadow_quality_option.add_item("Tắt", 0)
	shadow_quality_option.add_item("Thấp", 1)
	shadow_quality_option.add_item("Trung Bình", 2)
	shadow_quality_option.add_item("Cao", 3)
	shadow_quality_option.selected = 2
	graphics_tab.add_child(shadow_quality_option)

	# VSync
	vsync_check = CheckBox.new()
	vsync_check.text = "Bật VSync (chống giật)"
	vsync_check.button_pressed = true
	vsync_check.add_theme_font_size_override("font_size", 18)
	graphics_tab.add_child(vsync_check)

	# FPS Limit
	var fps_label = Label.new()
	fps_label.text = "Giới Hạn FPS:"
	fps_label.add_theme_font_size_override("font_size", 20)
	graphics_tab.add_child(fps_label)

	fps_limit_option = OptionButton.new()
	fps_limit_option.add_item("30 FPS", 30)
	fps_limit_option.add_item("60 FPS", 60)
	fps_limit_option.add_item("120 FPS", 120)
	fps_limit_option.add_item("Không giới hạn", 0)
	fps_limit_option.selected = 1
	graphics_tab.add_child(fps_limit_option)

func _setup_audio_tab() -> void:
	# Master Volume
	audio_tab.add_child(_create_volume_slider("🔊 Âm Lượng Chính:", "master"))

	# Music Volume
	audio_tab.add_child(_create_volume_slider("🎵 Nhạc Nền:", "music"))

	# SFX Volume
	audio_tab.add_child(_create_volume_slider("🔔 Hiệu Ứng Âm Thanh:", "sfx"))

func _create_volume_slider(label_text: String, type: String) -> VBoxContainer:
	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 8)

	var label = Label.new()
	label.text = label_text
	label.add_theme_font_size_override("font_size", 20)
	vbox.add_child(label)

	var hbox = HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 10)
	vbox.add_child(hbox)

	var slider = HSlider.new()
	slider.min_value = 0
	slider.max_value = 100
	slider.step = 1
	slider.custom_minimum_size = Vector2(600, 0)

	match type:
		"master":
			slider.value = AudioManager.master_volume * 100
			master_volume_slider = slider
			slider.value_changed.connect(_on_master_volume_changed)
		"music":
			slider.value = AudioManager.music_volume * 100
			music_volume_slider = slider
			slider.value_changed.connect(_on_music_volume_changed)
		"sfx":
			slider.value = AudioManager.sfx_volume * 100
			sfx_volume_slider = slider
			slider.value_changed.connect(_on_sfx_volume_changed)

	hbox.add_child(slider)

	var value_label = Label.new()
	value_label.text = str(int(slider.value)) + "%"
	value_label.custom_minimum_size = Vector2(60, 0)
	value_label.add_theme_font_size_override("font_size", 18)
	hbox.add_child(value_label)

	slider.value_changed.connect(func(val): value_label.text = str(int(val)) + "%")

	return vbox

func _setup_controls_tab() -> void:
	var info = Label.new()
	info.text = """ĐIỀU KHIỂN MẶC ĐỊNH:

🎮 DI CHUYỂN:
• WASD / Phím mũi tên - Di chuyển nhân vật
• Q/E - Xoay camera

🔧 TƯƠNG TÁC:
• E / Click chuột - Tương tác
• 1/2/3 - Chọn công cụ

📋 MENU:
• I / Tab - Kho đồ
• B - Cửa hàng
• C - Xây dựng
• ESC - Cài đặt / Tạm dừng

📸 CAMERA:
• Lăn chuột - Zoom in/out
• Q/E - Xoay camera
• F11 - Toàn màn hình
"""
	info.add_theme_font_size_override("font_size", 16)
	info.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	controls_tab.add_child(info)

func _style_panel(p: PanelContainer) -> void:
	var stylebox = StyleBoxFlat.new()
	stylebox.bg_color = Color(0.15, 0.15, 0.15, 0.95)
	stylebox.corner_radius_all = 15
	stylebox.border_width_all = 3
	stylebox.border_color = Color(0.3, 0.6, 0.3, 0.8)
	stylebox.shadow_color = Color(0, 0, 0, 0.5)
	stylebox.shadow_size = 10
	p.add_theme_stylebox_override("panel", stylebox)

func open() -> void:
	is_open = true
	visible = true
	get_tree().paused = true
	_load_current_settings()

	# Animate in
	panel.modulate.a = 0
	panel.scale = Vector2(0.8, 0.8)
	var tween = create_tween()
	tween.parallel().tween_property(panel, "modulate:a", 1.0, 0.3)
	tween.parallel().tween_property(panel, "scale", Vector2.ONE, 0.3)\
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func close() -> void:
	is_open = false

	# Animate out
	var tween = create_tween()
	tween.parallel().tween_property(panel, "modulate:a", 0.0, 0.2)
	tween.parallel().tween_property(panel, "scale", Vector2(0.8, 0.8), 0.2)
	await tween.finished

	visible = false
	get_tree().paused = false
	closed.emit()

func _load_current_settings() -> void:
	# Load current settings into UI
	if master_volume_slider:
		master_volume_slider.value = AudioManager.master_volume * 100
	if music_volume_slider:
		music_volume_slider.value = AudioManager.music_volume * 100
	if sfx_volume_slider:
		sfx_volume_slider.value = AudioManager.sfx_volume * 100

func _apply_settings() -> void:
	# Graphics
	var quality = graphics_quality_option.selected
	_apply_graphics_quality(quality)

	var shadow_quality = shadow_quality_option.selected
	_apply_shadow_quality(shadow_quality)

	# VSync
	if vsync_check.button_pressed:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

	# FPS Limit
	var fps = fps_limit_option.get_item_id(fps_limit_option.selected)
	Engine.max_fps = fps

	# Save settings
	_save_settings()

	settings_changed.emit()
	print("✅ Đã áp dụng cài đặt!")

func _apply_graphics_quality(quality: int) -> void:
	var viewport = get_viewport()
	if not viewport:
		return

	match quality:
		0:  # Low
			viewport.msaa_3d = Viewport.MSAA_DISABLED
			viewport.screen_space_aa = Viewport.SCREEN_SPACE_AA_DISABLED
			viewport.use_taa = false
		1:  # Medium
			viewport.msaa_3d = Viewport.MSAA_2X
			viewport.screen_space_aa = Viewport.SCREEN_SPACE_AA_FXAA
			viewport.use_taa = false
		2:  # High
			viewport.msaa_3d = Viewport.MSAA_4X
			viewport.screen_space_aa = Viewport.SCREEN_SPACE_AA_FXAA
			viewport.use_taa = false
		3:  # Ultra
			viewport.msaa_3d = Viewport.MSAA_4X
			viewport.screen_space_aa = Viewport.SCREEN_SPACE_AA_FXAA
			viewport.use_taa = true

func _apply_shadow_quality(quality: int) -> void:
	# Find directional light
	var light = get_tree().root.find_child("DirectionalLight3D", true, false)
	if not light or not light is DirectionalLight3D:
		return

	match quality:
		0:  # Off
			light.shadow_enabled = false
		1:  # Low
			light.shadow_enabled = true
			light.directional_shadow_mode = DirectionalLight3D.SHADOW_ORTHOGONAL
		2:  # Medium
			light.shadow_enabled = true
			light.directional_shadow_mode = DirectionalLight3D.SHADOW_PARALLEL_2_SPLITS
		3:  # High
			light.shadow_enabled = true
			light.directional_shadow_mode = DirectionalLight3D.SHADOW_PARALLEL_4_SPLITS

func _on_master_volume_changed(value: float) -> void:
	AudioManager.master_volume = value / 100.0

func _on_music_volume_changed(value: float) -> void:
	AudioManager.music_volume = value / 100.0

func _on_sfx_volume_changed(value: float) -> void:
	AudioManager.sfx_volume = value / 100.0
	# Play test sound
	AudioManager.play_sfx("ui_click")

func _save_settings() -> void:
	var config = ConfigFile.new()
	config.set_value("graphics", "quality", graphics_quality_option.selected)
	config.set_value("graphics", "shadow_quality", shadow_quality_option.selected)
	config.set_value("graphics", "vsync", vsync_check.button_pressed)
	config.set_value("graphics", "fps_limit", fps_limit_option.get_item_id(fps_limit_option.selected))
	config.save("user://settings.cfg")

	AudioManager.save_settings()
