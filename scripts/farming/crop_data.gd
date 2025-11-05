extends Resource
class_name CropData
## Dữ liệu cho một loại cây trồng

@export var crop_id: String = ""
@export var crop_name: String = ""
@export var seed_id: String = ""
@export var harvest_id: String = ""

@export_group("Growth")
@export var growth_stages: int = 4  # Số giai đoạn phát triển
@export var hours_per_stage: float = 24.0  # Số giờ mỗi giai đoạn
@export var regrow_time: float = 0.0  # Thời gian tái sinh (0 = không tái sinh)
@export var can_regrow: bool = false  # Có thể thu hoạch nhiều lần?

@export_group("Seasons")
@export var valid_seasons: Array[String] = ["spring", "summer", "fall", "winter"]

@export_group("Requirements")
@export var needs_water: bool = true  # Cần tưới nước?
@export var water_per_day: int = 1  # Số lần tưới mỗi ngày

@export_group("Yield")
@export var min_harvest: int = 1
@export var max_harvest: int = 3
@export var harvest_quality_range: Array[float] = [0.5, 1.0, 1.5]  # quality multipliers

## Kiểm tra có thể trồng trong mùa này không
func can_grow_in_season(season: String) -> bool:
	return season in valid_seasons

## Tính tổng thời gian phát triển
func get_total_growth_time() -> float:
	return growth_stages * hours_per_stage

## Lấy số lượng thu hoạch ngẫu nhiên
func get_random_harvest_amount() -> int:
	return randi_range(min_harvest, max_harvest)
