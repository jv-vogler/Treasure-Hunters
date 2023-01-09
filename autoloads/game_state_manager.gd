extends Node

const _SAVE_PATH = "user://save_games/"
const _VERSION = "1.0"

var settings := {}
var stats: Stats = preload("res://resources/stats.gd").new()
var inventory: Inventory = preload("res://resources/inventory.gd").new()
var levels_unlocked := []
var _game_state := {}
var _level_props := {}


func _ready() -> void:
	reset_state()
	_init_save_dir()
	SceneManager.connect("scene_reloaded", Callable(self, "_on_scene_reloaded"))


func save_file(file_name: String) -> void:
	var file = FileAccess.open(
		"%s/%s.sav" % [_SAVE_PATH, file_name], FileAccess.WRITE
	)
	if !file:
		printerr("Unable to save the file %s" % save_file)
		return

	_write_current_state()
	file.store_var(_game_state)


func load_file(file_name: String) -> void:
	var file = FileAccess.open(
		"%s/%s.sav" % [_SAVE_PATH, file_name], FileAccess.READ
	)
	if !file:
		printerr("Unable to load the file %s" % save_file)
		return

	var data = file.get_var()
	stats.adrenaline_decay = data.stats.adrenaline_decay
	stats.poison_decay = data.stats.poison_decay
	stats.max_health = data.stats.max_health
	stats.max_adrenaline = data.stats.max_adrenaline
	stats.max_poison = data.stats.max_poison
	stats.adrenaline_gain = data.stats.adrenaline_gain
	stats.strength = data.stats.strength
	stats.speed = data.stats.speed
	stats.jump_velocity = data.stats.jump_velocity
	stats.luck = data.stats.luck
	inventory.set_items(data.inventory)

	_level_props = data.level_props
	levels_unlocked = data.levels_unlocked
	settings = data.settings
	_write_current_state()


func delete_file(file_name: String) -> void:
	if file_name == "":
		printerr("No file name provided.")
		return

	var error = DirAccess.remove_absolute("%s/%s.sav" % [_SAVE_PATH, file_name])
	if error != OK:
		printerr("Failed to delete %s. Error: %s" % [file_name, error])


func get_save_names() -> Array:
	var dir = DirAccess.open(_SAVE_PATH)
	var files = dir.get_files()
	var file_names := []

	for file in files:
		file_names.push_back(file)

	return file_names


func get_saves_metadata() -> Dictionary:
	var meta_data := {}
	var file_names: Array[String] = get_save_names()

	for file_name in file_names:
		file_name = file_name.trim_suffix(".sav")

		var file = FileAccess.open(
			"%s/%s.sav" % [_SAVE_PATH, file_name], FileAccess.READ
		)
		var data = file.get_var()
		var currency := { "gold_coin": 0, "ruby": 0, "emerald": 0, "diamond": 0 }

		for i in data.inventory:
			match i.id:
				"gold_coin":
					currency["gold_coin"] = i.quantity
				"ruby":
					currency["ruby"] = i.quantity
				"emerald":
					currency["emerald"] = i.quantity
				"diamond":
					currency["diamond"] = i.quantity

		var unix_time = Time.get_unix_time_from_datetime_dict(data.current_datetime)
		meta_data[unix_time] = {
			"name": file_name,
			"levels_unlocked": data.levels_unlocked,
			"currency": currency,
		}
	return meta_data


func set_props(scene_path: String, props: Dictionary) -> void:
	_level_props[scene_path] = props


func get_props(scene_path: String) -> Dictionary:
	if scene_path in _level_props:
		var props = _level_props[scene_path].duplicate(true)
		return props
	return {}


func reset_state() -> void:
	stats.reset_to_default()
	inventory.reset_to_default()
	_level_props = {}
	levels_unlocked = ["res://levels/tutorial.tscn", "res://levels/level_1.tscn"]
	_write_current_state()


func _write_current_state() -> void:
	var current_state = {
		"stats": {
			"adrenaline_decay": stats.adrenaline_decay,
			"poison_decay": stats.poison_decay,
			"max_health": stats.max_health,
			"max_adrenaline": stats.max_adrenaline,
			"max_poison": stats.max_poison,
			"adrenaline_gain": stats.adrenaline_gain,
			"strength": stats.strength,
			"speed": stats.speed,
			"jump_velocity": stats.jump_velocity,
			"luck": stats.luck,
		},
		"inventory": inventory.get_items(),
		"level_props": _level_props,
		"levels_unlocked": levels_unlocked,
		"settings": settings,
		"current_datetime": Time.get_datetime_dict_from_system(),
		"version": _VERSION,
	}
	_game_state = current_state
	_d_dump_debug()


func _reload_state() -> void:
	stats.adrenaline_decay = _game_state.stats.adrenaline_decay
	stats.poison_decay = _game_state.stats.poison_decay
	stats.max_health = _game_state.stats.max_health
	stats.max_adrenaline = _game_state.stats.max_adrenaline
	stats.max_poison = _game_state.stats.max_poison
	stats.adrenaline_gain = _game_state.stats.adrenaline_gain
	stats.strength = _game_state.stats.strength
	stats.speed = _game_state.stats.speed
	stats.jump_velocity = _game_state.stats.jump_velocity
	stats.luck = _game_state.stats.luck
	inventory.set_items(_game_state.inventory)


func _init_save_dir() -> void:
	if !DirAccess.dir_exists_absolute(_SAVE_PATH):
		DirAccess.make_dir_absolute(_SAVE_PATH)


func _on_scene_reloaded() -> void:
	_reload_state()


func _d_dump_debug() -> void:
	var file = FileAccess.open("user://debug_state.json", FileAccess.WRITE)
	var data = JSON.stringify(_game_state)
	file.store_string(data)
