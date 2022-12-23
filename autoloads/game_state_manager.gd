extends Node

const _SAVE_PATH = "user://save_games/"
const _VERSION = "1.0"

var settings := {}
var stats: Stats = preload("res://resources/stats.gd").new()
var inventory: Inventory = preload("res://resources/inventory.gd").new()
var _game_state := {}
var _level_props := {}
var _level_snapshot := {}


func _ready() -> void:
	_reset_state()
	_init_save_dir()


func save_game(file_name: String) -> void:
	var save_file = FileAccess.open(
		"%s/%s.sav" % [_SAVE_PATH, file_name], FileAccess.WRITE
	)
	if !save_file:
		printerr("Unable to save the file %s" % save_file)
		return

	_write_current_state()
	save_file.store_var(_game_state)


func load_game(file_name: String) -> void:
	var save_file = FileAccess.open(
		"%s/%s.sav" % [_SAVE_PATH, file_name], FileAccess.READ
	)
	if !save_file:
		printerr("Unable to load the file %s" % save_file)
		return

	var data = save_file.get_var()
	stats.adrenaline_decay = data.stats.adrenaline_decay
	stats.poison_decay = data.stats.poison_decay
	stats.max_health = data.stats.max_health
	stats.max_adrenaline = data.stats.max_adrenaline
	stats.max_poison = data.stats.max_poison
	stats.adrenaline_gain = data.stats.adrenaline_gain
	stats.strength = data.stats.strength
	stats.speed = data.stats.speed
	stats.jump_velocity = data.stats.jump_velocity

	inventory.set_items(data.inventory)

	_level_props = data.level_props
	settings = data.settings
	_write_current_state()


func set_props(scene_path: String, props: Dictionary) -> void:
	_level_props[scene_path] = props
	_write_current_state()


func get_props(scene_path: String) -> Dictionary:
	if scene_path in _level_props:
		var props = _level_props[scene_path].duplicate(true)
		return props
	return {}


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
		},
		"inventory": inventory.get_items(),
		"level_props": _level_props,
		"settings": settings,
		"current_datetime": Time.get_datetime_dict_from_system(),
		"version": _VERSION,
	}
	_game_state = current_state
	_d_dump_debug()


func _write_snapshot() -> void:
	_level_snapshot = _game_state.duplicate(true)


func _load_state(state: Dictionary) -> void:
	stats.adrenaline_decay = state.stats.adrenaline_decay
	stats.poison_decay = state.stats.poison_decay
	stats.max_health = state.stats.max_health
	stats.max_adrenaline = state.stats.max_adrenaline
	stats.max_poison = state.stats.max_poison
	stats.adrenaline_gain = state.stats.adrenaline_gain
	stats.strength = state.stats.strength
	stats.speed = state.stats.speed
	stats.jump_velocity = state.stats.jump_velocity

	inventory.set_items(state.inventory)

	_level_props = state.level_props
	settings = state.settings


func _reset_state() -> void:
	stats.reset_to_default()
	inventory.reset_to_default()
	_level_props = {}
	_write_current_state()
	_write_snapshot()


func _init_save_dir() -> void:
	if !DirAccess.dir_exists_absolute(_SAVE_PATH):
		DirAccess.make_dir_absolute(_SAVE_PATH)


func _d_dump_debug() -> void:
	var file = FileAccess.open("user://debug_state.json", FileAccess.WRITE)
	var data = JSON.stringify(_game_state)
	file.store_string(data)
