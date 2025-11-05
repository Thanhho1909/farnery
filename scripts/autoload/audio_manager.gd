extends Node
## AudioManager - Quản lý âm thanh trong game
## Singleton tự động load

signal music_volume_changed(volume: float)
signal sfx_volume_changed(volume: float)

# Audio buses
const MASTER_BUS = "Master"
const MUSIC_BUS = "Music"
const SFX_BUS = "SFX"

# Volume settings (0.0 - 1.0)
var master_volume: float = 0.8:
	set(value):
		master_volume = clampf(value, 0.0, 1.0)
		_update_bus_volume(MASTER_BUS, master_volume)

var music_volume: float = 0.6:
	set(value):
		music_volume = clampf(value, 0.0, 1.0)
		_update_bus_volume(MUSIC_BUS, music_volume)
		music_volume_changed.emit(music_volume)

var sfx_volume: float = 0.8:
	set(value):
		sfx_volume = clampf(value, 0.0, 1.0)
		_update_bus_volume(SFX_BUS, sfx_volume)
		sfx_volume_changed.emit(sfx_volume)

# Music player
var music_player: AudioStreamPlayer
var current_music: String = ""

# SFX pool for performance
var sfx_pool: Array[AudioStreamPlayer] = []
const SFX_POOL_SIZE = 20

# SFX library (placeholder paths - add actual audio files)
const SFX_LIBRARY = {
	"ui_click": "res://audio/sfx/ui_click.ogg",
	"ui_hover": "res://audio/sfx/ui_hover.ogg",
	"till": "res://audio/sfx/till.ogg",
	"plant": "res://audio/sfx/plant.ogg",
	"water": "res://audio/sfx/water.ogg",
	"harvest": "res://audio/sfx/harvest.ogg",
	"coin": "res://audio/sfx/coin.ogg",
	"buy": "res://audio/sfx/buy.ogg",
	"sell": "res://audio/sfx/sell.ogg",
	"animal_feed": "res://audio/sfx/animal_feed.ogg",
	"animal_happy": "res://audio/sfx/animal_happy.ogg",
	"build": "res://audio/sfx/build.ogg",
	"craft": "res://audio/sfx/craft.ogg",
	"footstep": "res://audio/sfx/footstep.ogg",
	"door": "res://audio/sfx/door.ogg"
}

const MUSIC_LIBRARY = {
	"menu": "res://audio/music/menu.ogg",
	"spring": "res://audio/music/spring.ogg",
	"summer": "res://audio/music/summer.ogg",
	"fall": "res://audio/music/fall.ogg",
	"winter": "res://audio/music/winter.ogg"
}

func _ready() -> void:
	_setup_audio_buses()
	_setup_music_player()
	_setup_sfx_pool()
	print("🔊 Audio Manager khởi động!")

func _setup_audio_buses() -> void:
	# Setup audio buses if not exists
	# In actual project, configure buses in Audio settings
	pass

func _setup_music_player() -> void:
	music_player = AudioStreamPlayer.new()
	music_player.bus = MUSIC_BUS
	add_child(music_player)

func _setup_sfx_pool() -> void:
	for i in SFX_POOL_SIZE:
		var player = AudioStreamPlayer.new()
		player.bus = SFX_BUS
		add_child(player)
		sfx_pool.append(player)

## Play background music
func play_music(music_id: String, fade_duration: float = 1.0) -> void:
	if current_music == music_id and music_player.playing:
		return

	# Fade out current music
	if music_player.playing:
		var tween = create_tween()
		tween.tween_property(music_player, "volume_db", -80, fade_duration)
		await tween.finished

	# Load and play new music
	if MUSIC_LIBRARY.has(music_id):
		var music_path = MUSIC_LIBRARY[music_id]

		# Check if file exists
		if not FileAccess.file_exists(music_path):
			print("⚠️ Music file not found: ", music_path, " (using placeholder)")
			return

		var stream = load(music_path)
		if stream:
			music_player.stream = stream
			music_player.volume_db = -80
			music_player.play()
			current_music = music_id

			# Fade in
			var tween = create_tween()
			tween.tween_property(music_player, "volume_db", 0, fade_duration)
	else:
		push_error("Music not found: " + music_id)

## Stop music
func stop_music(fade_duration: float = 1.0) -> void:
	if music_player.playing:
		var tween = create_tween()
		tween.tween_property(music_player, "volume_db", -80, fade_duration)
		await tween.finished
		music_player.stop()
		current_music = ""

## Play sound effect
func play_sfx(sfx_id: String, pitch_scale: float = 1.0, volume_db: float = 0.0) -> void:
	if not SFX_LIBRARY.has(sfx_id):
		print("⚠️ SFX not found: ", sfx_id)
		return

	var sfx_path = SFX_LIBRARY[sfx_id]

	# Check if file exists
	if not FileAccess.file_exists(sfx_path):
		# Generate procedural sound as fallback
		_play_procedural_sfx(sfx_id, pitch_scale, volume_db)
		return

	# Find available player
	var player: AudioStreamPlayer = null
	for p in sfx_pool:
		if not p.playing:
			player = p
			break

	if not player:
		# All players busy, use the first one (override)
		player = sfx_pool[0]

	# Load and play
	var stream = load(sfx_path)
	if stream:
		player.stream = stream
		player.pitch_scale = pitch_scale
		player.volume_db = volume_db
		player.play()

## Play procedural sound (fallback when audio files don't exist)
func _play_procedural_sfx(sfx_id: String, pitch_scale: float, volume_db: float) -> void:
	# Create simple procedural sounds using AudioStreamGenerator
	var player = _get_available_sfx_player()
	if not player:
		return

	# Different procedural sounds based on type
	match sfx_id:
		"ui_click", "till", "plant", "harvest":
			_generate_click_sound(player, pitch_scale, volume_db)
		"water":
			_generate_splash_sound(player, pitch_scale, volume_db)
		"coin", "buy", "sell":
			_generate_coin_sound(player, pitch_scale, volume_db)
		_:
			print("⚠️ No procedural sound for: ", sfx_id)

func _get_available_sfx_player() -> AudioStreamPlayer:
	for player in sfx_pool:
		if not player.playing:
			return player
	return sfx_pool[0] if sfx_pool.size() > 0 else null

func _generate_click_sound(player: AudioStreamPlayer, pitch: float, volume: float) -> void:
	# Simple click/tap sound (placeholder - needs actual implementation)
	# For now, just print
	print("🔊 [Procedural] Click sound played")

func _generate_splash_sound(player: AudioStreamPlayer, pitch: float, volume: float) -> void:
	print("🔊 [Procedural] Splash sound played")

func _generate_coin_sound(player: AudioStreamPlayer, pitch: float, volume: float) -> void:
	print("🔊 [Procedural] Coin sound played")

## Play random pitch for variety
func play_sfx_random_pitch(sfx_id: String, min_pitch: float = 0.9, max_pitch: float = 1.1) -> void:
	var pitch = randf_range(min_pitch, max_pitch)
	play_sfx(sfx_id, pitch)

## Play 3D sound at position (for spatial audio)
func play_sfx_3d(sfx_id: String, position: Vector3, parent: Node3D) -> void:
	if not SFX_LIBRARY.has(sfx_id):
		return

	var player3d = AudioStreamPlayer3D.new()
	player3d.bus = SFX_BUS
	player3d.position = position
	player3d.max_distance = 20.0
	player3d.unit_size = 5.0

	var sfx_path = SFX_LIBRARY[sfx_id]
	if FileAccess.file_exists(sfx_path):
		var stream = load(sfx_path)
		if stream:
			player3d.stream = stream
			parent.add_child(player3d)
			player3d.play()

			# Auto cleanup
			await player3d.finished
			player3d.queue_free()
	else:
		print("⚠️ 3D SFX file not found: ", sfx_path)

## Update bus volume
func _update_bus_volume(bus_name: String, volume: float) -> void:
	var bus_idx = AudioServer.get_bus_index(bus_name)
	if bus_idx >= 0:
		# Convert linear volume to decibels
		var db = linear_to_db(volume)
		AudioServer.set_bus_volume_db(bus_idx, db)

## Mute/unmute all audio
func set_muted(muted: bool) -> void:
	var bus_idx = AudioServer.get_bus_index(MASTER_BUS)
	if bus_idx >= 0:
		AudioServer.set_bus_mute(bus_idx, muted)

## Save audio settings
func save_settings() -> void:
	var config = ConfigFile.new()
	config.set_value("audio", "master_volume", master_volume)
	config.set_value("audio", "music_volume", music_volume)
	config.set_value("audio", "sfx_volume", sfx_volume)
	config.save("user://audio_settings.cfg")

## Load audio settings
func load_settings() -> void:
	var config = ConfigFile.new()
	var err = config.load("user://audio_settings.cfg")
	if err == OK:
		master_volume = config.get_value("audio", "master_volume", 0.8)
		music_volume = config.get_value("audio", "music_volume", 0.6)
		sfx_volume = config.get_value("audio", "sfx_volume", 0.8)
