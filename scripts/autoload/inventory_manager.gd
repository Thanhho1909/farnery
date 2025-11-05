extends Node
## InventoryManager - Quản lý kho đồ người chơi
## Singleton tự động load

signal inventory_changed()
signal item_added(item_id: String, quantity: int)
signal item_removed(item_id: String, quantity: int)

# Inventory storage: {item_id: quantity}
var items: Dictionary = {}

# Item database
const ITEMS = {
	# Seeds
	"seed_carrot": {"name": "Hạt cà rốt", "type": "seed", "sell_price": 5, "buy_price": 10},
	"seed_tomato": {"name": "Hạt cà chua", "type": "seed", "sell_price": 8, "buy_price": 15},
	"seed_wheat": {"name": "Hạt lúa mì", "type": "seed", "sell_price": 3, "buy_price": 6},
	"seed_corn": {"name": "Hạt ngô", "type": "seed", "sell_price": 6, "buy_price": 12},
	"seed_potato": {"name": "Hạt khoai tây", "type": "seed", "sell_price": 4, "buy_price": 8},

	# Crops
	"carrot": {"name": "Cà rốt", "type": "crop", "sell_price": 30, "buy_price": 0},
	"tomato": {"name": "Cà chua", "type": "crop", "sell_price": 40, "buy_price": 0},
	"wheat": {"name": "Lúa mì", "type": "crop", "sell_price": 20, "buy_price": 0},
	"corn": {"name": "Ngô", "type": "crop", "sell_price": 35, "buy_price": 0},
	"potato": {"name": "Khoai tây", "type": "crop", "sell_price": 25, "buy_price": 0},

	# Animal products
	"egg": {"name": "Trứng gà", "type": "animal_product", "sell_price": 15, "buy_price": 0},
	"milk": {"name": "Sữa bò", "type": "animal_product", "sell_price": 25, "buy_price": 0},
	"wool": {"name": "Len cừu", "type": "animal_product", "sell_price": 35, "buy_price": 0},
	"honey": {"name": "Mật ong", "type": "animal_product", "sell_price": 50, "buy_price": 0},

	# Processed goods
	"flour": {"name": "Bột mì", "type": "processed", "sell_price": 40, "buy_price": 0},
	"bread": {"name": "Bánh mì", "type": "processed", "sell_price": 80, "buy_price": 0},
	"cheese": {"name": "Phô mai", "type": "processed", "sell_price": 60, "buy_price": 0},

	# Animal feed
	"animal_feed": {"name": "Thức ăn chăn nuôi", "type": "feed", "sell_price": 5, "buy_price": 10},

	# Tools (not sold, upgrade only)
	"watering_can": {"name": "Bình tưới", "type": "tool", "sell_price": 0, "buy_price": 0},
	"hoe": {"name": "Cuốc", "type": "tool", "sell_price": 0, "buy_price": 0},
	"axe": {"name": "Rìu", "type": "tool", "sell_price": 0, "buy_price": 0},
}

func _ready() -> void:
	print("🎒 Inventory Manager khởi động!")
	# Give starter items
	add_item("seed_carrot", 10)
	add_item("seed_wheat", 15)
	add_item("watering_can", 1)
	add_item("hoe", 1)

## Thêm vật phẩm vào kho
func add_item(item_id: String, quantity: int = 1) -> void:
	if not ITEMS.has(item_id):
		push_error("Item không tồn tại: " + item_id)
		return

	if items.has(item_id):
		items[item_id] += quantity
	else:
		items[item_id] = quantity

	item_added.emit(item_id, quantity)
	inventory_changed.emit()
	print("📦 +" + str(quantity) + " " + ITEMS[item_id]["name"])

## Xóa vật phẩm khỏi kho
func remove_item(item_id: String, quantity: int = 1) -> bool:
	if not has_item(item_id, quantity):
		return false

	items[item_id] -= quantity
	if items[item_id] <= 0:
		items.erase(item_id)

	item_removed.emit(item_id, quantity)
	inventory_changed.emit()
	print("📦 -" + str(quantity) + " " + ITEMS[item_id]["name"])
	return true

## Kiểm tra có đủ vật phẩm không
func has_item(item_id: String, quantity: int = 1) -> bool:
	return items.get(item_id, 0) >= quantity

## Lấy số lượng vật phẩm
func get_item_count(item_id: String) -> int:
	return items.get(item_id, 0)

## Lấy thông tin vật phẩm
func get_item_info(item_id: String) -> Dictionary:
	return ITEMS.get(item_id, {})

## Lấy tên vật phẩm
func get_item_name(item_id: String) -> String:
	return ITEMS.get(item_id, {}).get("name", "Unknown")

## Bán vật phẩm
func sell_item(item_id: String, quantity: int = 1) -> bool:
	if not has_item(item_id, quantity):
		return false

	var item_info = get_item_info(item_id)
	var sell_price = item_info.get("sell_price", 0)
	var total_price = sell_price * quantity

	if remove_item(item_id, quantity):
		GameManager.add_money(total_price)
		return true

	return false

## Mua vật phẩm
func buy_item(item_id: String, quantity: int = 1) -> bool:
	var item_info = get_item_info(item_id)
	var buy_price = item_info.get("buy_price", 0)

	if buy_price == 0:
		print("❌ Vật phẩm này không thể mua!")
		return false

	var total_price = buy_price * quantity

	if GameManager.spend_money(total_price):
		add_item(item_id, quantity)
		return true

	return false

## Lấy danh sách vật phẩm theo loại
func get_items_by_type(item_type: String) -> Array:
	var result = []
	for item_id in ITEMS.keys():
		if ITEMS[item_id].get("type") == item_type:
			result.append(item_id)
	return result
