extends Node
## GameManager - Quản lý trạng thái game chính
## Singleton tự động load, quản lý các hệ thống core

signal money_changed(new_amount: int)
signal day_changed(day: int)
signal season_changed(season: String)

# Game state
var money: int = 1000:
	set(value):
		money = value
		money_changed.emit(money)

var player_name: String = "Người chơi"
var farm_name: String = "Nông trại mơ ước"

# Time tracking
var current_day: int = 1:
	set(value):
		current_day = value
		day_changed.emit(current_day)
		_check_season_change()

var current_season: String = "spring":
	set(value):
		if current_season != value:
			current_season = value
			season_changed.emit(current_season)

var game_time: float = 6.0  # Starts at 6 AM

# Constants
const DAYS_PER_SEASON = 28
const SEASONS = ["spring", "summer", "fall", "winter"]
const SEASON_NAMES_VI = {
	"spring": "Xuân",
	"summer": "Hạ",
	"fall": "Thu",
	"winter": "Đông"
}

func _ready() -> void:
	print("🌾 Game Manager khởi động!")
	print("💰 Tiền ban đầu: ", money)
	print("📅 Ngày: ", current_day, " - Mùa: ", get_season_name_vi())

## Thêm tiền
func add_money(amount: int) -> void:
	money += amount
	print("💰 +", amount, " xu (Tổng: ", money, ")")

## Trừ tiền, trả về true nếu thành công
func spend_money(amount: int) -> bool:
	if money >= amount:
		money -= amount
		print("💰 -", amount, " xu (Còn: ", money, ")")
		return true
	else:
		print("❌ Không đủ tiền! Cần ", amount, " xu, chỉ có ", money)
		return false

## Tiến sang ngày mới
func advance_day() -> void:
	current_day += 1
	game_time = 6.0
	print("🌅 Ngày mới: ", current_day, " - ", get_season_name_vi())

## Kiểm tra thay đổi mùa
func _check_season_change() -> void:
	var season_index = ((current_day - 1) / DAYS_PER_SEASON) % 4
	var new_season = SEASONS[season_index]
	if new_season != current_season:
		current_season = new_season
		print("🍂 Chuyển sang mùa: ", get_season_name_vi())

## Lấy tên mùa tiếng Việt
func get_season_name_vi() -> String:
	return SEASON_NAMES_VI.get(current_season, current_season)

## Lấy ngày trong mùa (1-28)
func get_day_in_season() -> int:
	return ((current_day - 1) % DAYS_PER_SEASON) + 1

## Lưu game
func save_game() -> void:
	var save_data = {
		"money": money,
		"player_name": player_name,
		"farm_name": farm_name,
		"current_day": current_day,
		"current_season": current_season,
		"game_time": game_time
	}

	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	if save_file:
		save_file.store_var(save_data)
		save_file.close()
		print("💾 Đã lưu game!")
	else:
		push_error("Không thể lưu game!")

## Load game
func load_game() -> bool:
	if not FileAccess.file_exists("user://savegame.save"):
		print("📂 Không tìm thấy file save")
		return false

	var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
	if save_file:
		var save_data = save_file.get_var()
		save_file.close()

		money = save_data.get("money", 1000)
		player_name = save_data.get("player_name", "Người chơi")
		farm_name = save_data.get("farm_name", "Nông trại mơ ước")
		current_day = save_data.get("current_day", 1)
		current_season = save_data.get("current_season", "spring")
		game_time = save_data.get("game_time", 6.0)

		print("📂 Đã load game!")
		return true
	return false
