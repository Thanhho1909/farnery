extends CanvasLayer
## Shop UI - Giao diện mua bán

signal closed()

var is_open: bool = false
var panel: PanelContainer
var item_list: VBoxContainer
var close_button: Button

# Shop inventory with seasonal pricing
const SHOP_ITEMS = {
	"seed_carrot": {"base_price": 10, "seasonal_multiplier": {"spring": 1.0, "summer": 1.2, "fall": 0.9, "winter": 1.3}},
	"seed_tomato": {"base_price": 15, "seasonal_multiplier": {"spring": 1.1, "summer": 0.8, "fall": 1.0, "winter": 1.5}},
	"seed_wheat": {"base_price": 6, "seasonal_multiplier": {"spring": 0.9, "summer": 1.0, "fall": 0.8, "winter": 1.2}},
	"seed_corn": {"base_price": 12, "seasonal_multiplier": {"spring": 1.2, "summer": 0.9, "fall": 1.1, "winter": 1.5}},
	"seed_potato": {"base_price": 8, "seasonal_multiplier": {"spring": 0.9, "summer": 1.2, "fall": 0.8, "winter": 1.0}},
	"animal_feed": {"base_price": 10, "seasonal_multiplier": {"spring": 1.0, "summer": 1.0, "fall": 1.0, "winter": 1.1}},
}

func _ready() -> void:
	_setup_ui()
	visible = false

	# Listen for shop key
	set_process_input(true)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("open_shop"):
		if is_open:
			close_shop()
		else:
			open_shop()

func _setup_ui() -> void:
	# Main panel
	panel = PanelContainer.new()
	panel.position = Vector2(300, 150)
	panel.size = Vector2(1320, 780)
	add_child(panel)

	# Container
	var margin = MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 20)
	margin.add_theme_constant_override("margin_right", 20)
	margin.add_theme_constant_override("margin_top", 20)
	margin.add_theme_constant_override("margin_bottom", 20)
	panel.add_child(margin)

	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 15)
	margin.add_child(vbox)

	# Title
	var title = Label.new()
	title.text = "🏪 CỬA HÀNG NÔNG TRẠI"
	title.add_theme_font_size_override("font_size", 32)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title)

	# Info label
	var info = Label.new()
	info.text = "Giá thay đổi theo mùa vụ!"
	info.add_theme_font_size_override("font_size", 18)
	info.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(info)

	# Scroll container for items
	var scroll = ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(0, 600)
	vbox.add_child(scroll)

	item_list = VBoxContainer.new()
	item_list.add_theme_constant_override("separation", 10)
	scroll.add_child(item_list)

	# Close button
	close_button = Button.new()
	close_button.text = "Đóng (B)"
	close_button.add_theme_font_size_override("font_size", 20)
	close_button.pressed.connect(close_shop)
	vbox.add_child(close_button)

func open_shop() -> void:
	is_open = true
	visible = true
	_populate_shop()
	print("🏪 Mở cửa hàng")

func close_shop() -> void:
	is_open = false
	visible = false
	closed.emit()
	print("🏪 Đóng cửa hàng")

func _populate_shop() -> void:
	# Clear existing items
	for child in item_list.get_children():
		child.queue_free()

	# Add shop items
	for item_id in SHOP_ITEMS.keys():
		_add_shop_item(item_id)

func _add_shop_item(item_id: String) -> void:
	var item_info = InventoryManager.get_item_info(item_id)
	var shop_info = SHOP_ITEMS[item_id]

	# Calculate seasonal price
	var base_price = shop_info["base_price"]
	var season_mult = shop_info["seasonal_multiplier"].get(GameManager.current_season, 1.0)
	var final_price = int(base_price * season_mult)

	# Item container
	var hbox = HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 20)

	# Item name
	var name_label = Label.new()
	name_label.text = item_info.get("name", "Unknown")
	name_label.add_theme_font_size_override("font_size", 20)
	name_label.custom_minimum_size = Vector2(300, 0)
	hbox.add_child(name_label)

	# Price label
	var price_label = Label.new()
	if season_mult != 1.0:
		price_label.text = "%d xu (x%.1f)" % [final_price, season_mult]
	else:
		price_label.text = "%d xu" % final_price
	price_label.add_theme_font_size_override("font_size", 20)
	price_label.custom_minimum_size = Vector2(200, 0)
	hbox.add_child(price_label)

	# Buy buttons
	for amount in [1, 5, 10]:
		var button = Button.new()
		button.text = "Mua x%d" % amount
		button.add_theme_font_size_override("font_size", 18)
		button.pressed.connect(_on_buy_item.bind(item_id, amount, final_price))
		hbox.add_child(button)

	# Sell button (if player has item)
	if InventoryManager.has_item(item_id, 1):
		var sell_price = item_info.get("sell_price", 0)
		if sell_price > 0:
			var sell_button = Button.new()
			sell_button.text = "Bán (-%d)" % sell_price
			sell_button.add_theme_font_size_override("font_size", 18)
			sell_button.pressed.connect(_on_sell_item.bind(item_id, 1))
			hbox.add_child(sell_button)

	item_list.add_child(hbox)

func _on_buy_item(item_id: String, amount: int, price_per_item: int) -> void:
	var total_price = price_per_item * amount

	if GameManager.money >= total_price:
		GameManager.spend_money(total_price)
		InventoryManager.add_item(item_id, amount)
		print("✅ Đã mua x%d %s" % [amount, InventoryManager.get_item_name(item_id)])
		_populate_shop()  # Refresh
	else:
		print("❌ Không đủ tiền!")

func _on_sell_item(item_id: String, amount: int) -> void:
	if InventoryManager.sell_item(item_id, amount):
		print("✅ Đã bán x%d %s" % [amount, InventoryManager.get_item_name(item_id)])
		_populate_shop()  # Refresh
	else:
		print("❌ Không có đủ để bán!")
