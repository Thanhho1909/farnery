extends Node
## WeatherSystem - Hệ thống thời tiết ảnh hưởng gameplay
## Singleton tự động load

signal weather_changed(new_weather: String)
signal rain_started()
signal rain_stopped()

enum Weather { SUNNY, CLOUDY, RAINY, STORMY }

var current_weather: Weather = Weather.SUNNY:
	set(value):
		if current_weather != value:
			var old_weather = current_weather
			current_weather = value
			weather_changed.emit(get_weather_name())
			_on_weather_changed(old_weather, current_weather)

var is_raining: bool = false:
	set(value):
		if is_raining != value:
			is_raining = value
			if is_raining:
				rain_started.emit()
			else:
				rain_stopped.emit()

# Weather probabilities by season
const SEASON_WEATHER_CHANCES = {
	"spring": {
		Weather.SUNNY: 0.4,
		Weather.CLOUDY: 0.3,
		Weather.RAINY: 0.25,
		Weather.STORMY: 0.05
	},
	"summer": {
		Weather.SUNNY: 0.6,
		Weather.CLOUDY: 0.25,
		Weather.RAINY: 0.1,
		Weather.STORMY: 0.05
	},
	"fall": {
		Weather.SUNNY: 0.3,
		Weather.CLOUDY: 0.4,
		Weather.RAINY: 0.25,
		Weather.STORMY: 0.05
	},
	"winter": {
		Weather.SUNNY: 0.2,
		Weather.CLOUDY: 0.5,
		Weather.RAINY: 0.2,
		Weather.STORMY: 0.1
	}
}

# Weather effects on gameplay
const WEATHER_EFFECTS = {
	Weather.SUNNY: {
		"crop_growth_multiplier": 1.1,
		"animal_happiness_bonus": 5.0,
		"auto_water": false
	},
	Weather.CLOUDY: {
		"crop_growth_multiplier": 1.0,
		"animal_happiness_bonus": 0.0,
		"auto_water": false
	},
	Weather.RAINY: {
		"crop_growth_multiplier": 1.2,
		"animal_happiness_bonus": -5.0,
		"auto_water": true,  # Rain waters crops automatically
		"milk_production_penalty": 0.1,
		"egg_production_penalty": 0.1
	},
	Weather.STORMY: {
		"crop_growth_multiplier": 0.8,
		"animal_happiness_bonus": -10.0,
		"auto_water": true,
		"milk_production_penalty": 0.3,
		"egg_production_penalty": 0.2
	}
}

func _ready() -> void:
	print("🌤️ Weather System khởi động!")
	GameManager.day_changed.connect(_on_new_day)
	GameManager.season_changed.connect(_on_season_changed)

	# Set initial weather
	_randomize_weather()

## Called when a new day starts
func _on_new_day(day: int) -> void:
	_randomize_weather()

## Called when season changes
func _on_season_changed(season: String) -> void:
	print("🍂 Mùa đã đổi sang ", season, ", thời tiết thay đổi!")
	_randomize_weather()

## Randomize weather based on season
func _randomize_weather() -> void:
	var season = GameManager.current_season
	var chances = SEASON_WEATHER_CHANCES.get(season, SEASON_WEATHER_CHANCES["spring"])

	var roll = randf()
	var cumulative = 0.0

	for weather_type in chances.keys():
		cumulative += chances[weather_type]
		if roll <= cumulative:
			current_weather = weather_type
			break

	is_raining = current_weather in [Weather.RAINY, Weather.STORMY]
	print("🌤️ Thời tiết hôm nay: ", get_weather_name())

## Get weather name in Vietnamese
func get_weather_name() -> String:
	match current_weather:
		Weather.SUNNY:
			return "Nắng"
		Weather.CLOUDY:
			return "Nhiều mây"
		Weather.RAINY:
			return "Mưa"
		Weather.STORMY:
			return "Bão"
	return "Unknown"

## Get weather icon emoji
func get_weather_icon() -> String:
	match current_weather:
		Weather.SUNNY:
			return "☀️"
		Weather.CLOUDY:
			return "☁️"
		Weather.RAINY:
			return "🌧️"
		Weather.STORMY:
			return "⛈️"
	return "🌤️"

## Get crop growth multiplier
func get_crop_growth_multiplier() -> float:
	return WEATHER_EFFECTS[current_weather].get("crop_growth_multiplier", 1.0)

## Get animal happiness bonus/penalty
func get_animal_happiness_modifier() -> float:
	return WEATHER_EFFECTS[current_weather].get("animal_happiness_bonus", 0.0)

## Check if rain auto-waters crops
func does_auto_water() -> bool:
	return WEATHER_EFFECTS[current_weather].get("auto_water", false)

## Get animal production penalty
func get_production_penalty(product_type: String) -> float:
	var key = product_type + "_production_penalty"
	return WEATHER_EFFECTS[current_weather].get(key, 0.0)

## Called when weather changes
func _on_weather_changed(old_weather: Weather, new_weather: Weather) -> void:
	print("🌤️ Thời tiết chuyển từ ", _get_weather_name_for(old_weather), " sang ", get_weather_name())

	# Apply immediate effects
	if does_auto_water():
		print("💧 Mưa đang tưới nước cho cây!")

func _get_weather_name_for(weather: Weather) -> String:
	match weather:
		Weather.SUNNY:
			return "Nắng"
		Weather.CLOUDY:
			return "Nhiều mây"
		Weather.RAINY:
			return "Mưa"
		Weather.STORMY:
			return "Bão"
	return "Unknown"

## Get full weather info
func get_weather_info() -> String:
	var info = "%s %s\n" % [get_weather_icon(), get_weather_name()]

	var effects = WEATHER_EFFECTS[current_weather]
	if effects.get("crop_growth_multiplier", 1.0) != 1.0:
		var percent = int((effects["crop_growth_multiplier"] - 1.0) * 100)
		info += "Tăng trưởng cây: %+d%%\n" % percent

	if effects.get("animal_happiness_bonus", 0.0) != 0.0:
		info += "Tâm trạng vật nuôi: %+d\n" % int(effects["animal_happiness_bonus"])

	if effects.get("auto_water", false):
		info += "Tự động tưới nước!\n"

	return info
