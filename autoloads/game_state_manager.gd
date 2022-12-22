extends Node

const SAVE_PATH = "user://save_games/"

var settings := {}
var stats = preload("res://resources/stats.gd").new()
var inventory = preload("res://resources/inventory.gd").new()
var _level_props := {}
var _game_state := {}


func _ready() -> void:
	_reset_state()


func save_game(_file_name: String) -> void:
	pass


func load_game(_file_name: String) -> void:
	pass


func set_props(scene_path: String, props: Dictionary) -> void:
	_level_props[scene_path] = props
	_write_current_state()


func get_props(scene_path: String) -> Dictionary:
	if scene_path in _level_props:
		return _level_props[scene_path]
	return {}


func _write_current_state() -> void:
	var _snapshot = {
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
		"inventory": {
			"items": inventory.get_items()
		},
		"level_props": _level_props,
		"settings": settings,
	}
	_game_state = _snapshot


func _reset_state() -> void:
	stats.reset_to_default()
	inventory.reset_to_default()
	_level_props = {}
	_write_current_state()
