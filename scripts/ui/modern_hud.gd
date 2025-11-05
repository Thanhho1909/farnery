extends CanvasLayer
## Modern HUD with improved visuals and animations

var money_label: Label
var day_label: Label
var season_label: Label
var weather_label: Label
var time_label: Label
var fps_label: Label

# Containers
var top_left_panel: PanelContainer
var top_right_panel: PanelContainer
var notification_container: VBoxContainer

# Notification system
const NOTIFICATION_DURATION = 3.0

func _ready() -> void:
	add_to_group("hud")
	_setup_ui()
	_connect_signals()
	_update_all()

func _setup_ui() -> void:
	# Top left panel (game info)
	top_left_panel = PanelContainer.new()
	top_left_panel.position = Vector2(20, 20)
	_style_panel(top_left_panel)
	add_child(top_left_panel)

	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 8)
	top_left_panel.add_child(vbox)

	# Money with icon
	var money_hbox = HBoxContainer.new()
	var money_icon = Label.new()
	money_icon.text = "💰"
	money_icon.add_theme_font_size_override("font_size", 24)
	money_hbox.add_child(money_icon)

	money_label = Label.new()
	money_label.add_theme_font_size_override("font_size", 20)
	money_hbox.add_child(money_label)
	vbox.add_child(money_hbox)

	# Day info
	day_label = Label.new()
	day_label.add_theme_font_size_override("font_size", 18)
	vbox.add_child(day_label)

	# Season
	season_label = Label.new()
	season_label.add_theme_font_size_override("font_size", 18)
	vbox.add_child(season_label)

	# Weather
	weather_label = Label.new()
	weather_label.add_theme_font_size_override("font_size", 18)
	vbox.add_child(weather_label)

	# Time
	time_label = Label.new()
	time_label.add_theme_font_size_override("font_size", 16)
	vbox.add_child(time_label)

	# Top right panel (performance)
	top_right_panel = PanelContainer.new()
	top_right_panel.position = Vector2(1720, 20)
	_style_panel(top_right_panel)
	add_child(top_right_panel)

	fps_label = Label.new()
	fps_label.add_theme_font_size_override("font_size", 16)
	fps_label.add_theme_color_override("font_color", Color(0.5, 1, 0.5))
	top_right_panel.add_child(fps_label)

	# Notification container (top center)
	notification_container = VBoxContainer.new()
	notification_container.position = Vector2(760, 100)
	notification_container.size = Vector2(400, 0)
	notification_container.add_theme_constant_override("separation", 10)
	add_child(notification_container)

func _style_panel(panel: PanelContainer) -> void:
	var stylebox = StyleBoxFlat.new()
	stylebox.bg_color = Color(0.1, 0.1, 0.1, 0.8)
	stylebox.corner_radius_top_left = 10
	stylebox.corner_radius_top_right = 10
	stylebox.corner_radius_bottom_left = 10
	stylebox.corner_radius_bottom_right = 10
	stylebox.content_margin_left = 15
	stylebox.content_margin_right = 15
	stylebox.content_margin_top = 10
	stylebox.content_margin_bottom = 10
	stylebox.border_width_all = 2
	stylebox.border_color = Color(0.3, 0.6, 0.3, 0.5)
	panel.add_theme_stylebox_override("panel", stylebox)

func _connect_signals() -> void:
	GameManager.money_changed.connect(_on_money_changed)
	GameManager.day_changed.connect(_on_day_changed)
	GameManager.season_changed.connect(_on_season_changed)
	WeatherSystem.weather_changed.connect(_on_weather_changed)

	# Inventory changes
	if InventoryManager:
		InventoryManager.item_added.connect(_on_item_added)

func _process(_delta: float) -> void:
	_update_time()
	_update_fps()

func _update_all() -> void:
	_update_money()
	_update_day()
	_update_season()
	_update_weather()
	_update_time()

func _update_money() -> void:
	money_label.text = "%d xu" % GameManager.money

func _on_money_changed(new_amount: int) -> void:
	_update_money()

	# Animate money label
	if money_label:
		var tween = create_tween()
		tween.tween_property(money_label, "scale", Vector2(1.2, 1.2), 0.1)
		tween.tween_property(money_label, "scale", Vector2.ONE, 0.1)

		# Flash color
		var original_color = money_label.get_theme_color("font_color")
		money_label.add_theme_color_override("font_color", Color.YELLOW)
		await get_tree().create_timer(0.2).timeout
		money_label.remove_theme_color_override("font_color")

func _update_day() -> void:
	day_label.text = "📅 Ngày %d (%d/%d)" % [
		GameManager.current_day,
		GameManager.get_day_in_season(),
		GameManager.DAYS_PER_SEASON
	]

func _on_day_changed(day: int) -> void:
	_update_day()
	show_notification("🌅 Ngày mới: Ngày %d" % day, Color(1, 0.9, 0.5))

func _update_season() -> void:
	season_label.text = "🍂 Mùa: %s" % GameManager.get_season_name_vi()

func _on_season_changed(season: String) -> void:
	_update_season()
	show_notification("🍂 Chuyển sang mùa %s!" % GameManager.get_season_name_vi(), Color(0.8, 0.5, 1))

func _update_weather() -> void:
	weather_label.text = "%s %s" % [
		WeatherSystem.get_weather_icon(),
		WeatherSystem.get_weather_name()
	]

func _on_weather_changed(weather: String) -> void:
	_update_weather()

func _update_time() -> void:
	var hours = int(GameManager.game_time)
	var minutes = int((GameManager.game_time - hours) * 60)
	time_label.text = "🕐 %02d:%02d" % [hours, minutes]

func _update_fps() -> void:
	fps_label.text = "FPS: %d" % Engine.get_frames_per_second()

	# Color based on FPS
	var fps = Engine.get_frames_per_second()
	if fps >= 50:
		fps_label.add_theme_color_override("font_color", Color(0.5, 1, 0.5))
	elif fps >= 30:
		fps_label.add_theme_color_override("font_color", Color(1, 1, 0.5))
	else:
		fps_label.add_theme_color_override("font_color", Color(1, 0.5, 0.5))

func _on_item_added(item_id: String, quantity: int) -> void:
	var item_name = InventoryManager.get_item_name(item_id)
	show_notification("📦 +%d %s" % [quantity, item_name], Color(0.5, 1, 0.8))

## Show notification popup
func show_notification(text: String, color: Color = Color.WHITE) -> void:
	var notification = _create_notification(text, color)
	notification_container.add_child(notification)

	# Slide in
	notification.position.x = -400
	var tween = create_tween()
	tween.tween_property(notification, "position:x", 0, 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	# Wait and fade out
	await get_tree().create_timer(NOTIFICATION_DURATION).timeout

	tween = create_tween()
	tween.tween_property(notification, "modulate:a", 0.0, 0.3)
	await tween.finished
	notification.queue_free()

func _create_notification(text: String, color: Color) -> PanelContainer:
	var panel = PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var stylebox = StyleBoxFlat.new()
	stylebox.bg_color = Color(0.1, 0.1, 0.1, 0.9)
	stylebox.corner_radius_all = 8
	stylebox.content_margin_all = 12
	stylebox.border_width_all = 2
	stylebox.border_color = color
	panel.add_theme_stylebox_override("panel", stylebox)

	var label = Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", 18)
	label.add_theme_color_override("font_color", color)
	panel.add_child(label)

	return panel

## Show hint
func show_hint(text: String, duration: float = 3.0) -> void:
	show_notification("💡 " + text, Color(1, 1, 0.5))
