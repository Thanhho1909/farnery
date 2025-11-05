extends CanvasLayer
## HUD - Hiển thị thông tin game chính

var money_label: Label
var day_label: Label
var season_label: Label
var weather_label: Label
var time_label: Label
var hint_label: Label

func _ready() -> void:
	_setup_ui()

	# Connect to game signals
	GameManager.money_changed.connect(_on_money_changed)
	GameManager.day_changed.connect(_on_day_changed)
	GameManager.season_changed.connect(_on_season_changed)
	WeatherSystem.weather_changed.connect(_on_weather_changed)

	# Initial update
	_update_all()

func _setup_ui() -> void:
	# Create container for top-left info
	var info_container = VBoxContainer.new()
	info_container.position = Vector2(20, 20)
	info_container.add_theme_constant_override("separation", 5)
	add_child(info_container)

	# Money label
	money_label = Label.new()
	money_label.add_theme_font_size_override("font_size", 24)
	info_container.add_child(money_label)

	# Day label
	day_label = Label.new()
	day_label.add_theme_font_size_override("font_size", 20)
	info_container.add_child(day_label)

	# Season label
	season_label = Label.new()
	season_label.add_theme_font_size_override("font_size", 20)
	info_container.add_child(season_label)

	# Weather label
	weather_label = Label.new()
	weather_label.add_theme_font_size_override("font_size", 20)
	info_container.add_child(weather_label)

	# Time label
	time_label = Label.new()
	time_label.add_theme_font_size_override("font_size", 18)
	info_container.add_child(time_label)

	# Hint label (bottom center)
	hint_label = Label.new()
	hint_label.add_theme_font_size_override("font_size", 18)
	hint_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hint_label.position = Vector2(960 - 200, 1000)  # Center bottom
	hint_label.size = Vector2(400, 50)
	hint_label.text = "WASD: Di chuyển | E: Tương tác | I: Kho đồ | B: Cửa hàng | C: Xây dựng"
	add_child(hint_label)

func _process(_delta: float) -> void:
	_update_time()

func _update_all() -> void:
	_update_money()
	_update_day()
	_update_season()
	_update_weather()
	_update_time()

func _update_money() -> void:
	money_label.text = "💰 Tiền: %d xu" % GameManager.money

func _update_day() -> void:
	day_label.text = "📅 Ngày %d (%d/%d)" % [
		GameManager.current_day,
		GameManager.get_day_in_season(),
		GameManager.DAYS_PER_SEASON
	]

func _update_season() -> void:
	season_label.text = "🍂 Mùa: %s" % GameManager.get_season_name_vi()

func _update_weather() -> void:
	weather_label.text = "%s %s" % [
		WeatherSystem.get_weather_icon(),
		WeatherSystem.get_weather_name()
	]

func _update_time() -> void:
	var hours = int(GameManager.game_time)
	var minutes = int((GameManager.game_time - hours) * 60)
	time_label.text = "🕐 %02d:%02d" % [hours, minutes]

func _on_money_changed(new_amount: int) -> void:
	_update_money()

func _on_day_changed(day: int) -> void:
	_update_day()

func _on_season_changed(season: String) -> void:
	_update_season()

func _on_weather_changed(weather: String) -> void:
	_update_weather()

func show_hint(text: String, duration: float = 3.0) -> void:
	hint_label.text = text
	await get_tree().create_timer(duration).timeout
	hint_label.text = "WASD: Di chuyển | E: Tương tác | I: Kho đồ | B: Cửa hàng | C: Xây dựng"
