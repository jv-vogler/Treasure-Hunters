extends Node

var Stats = preload("res://resources/stats.gd").new()
var Inventory = preload("res://resources/inventory.gd").new()
var _game_state := {}
var _snapshot := {}


func _ready() -> void:
	_reset_state()


func save_game(_file_name: String) -> void:
	pass


func load_game(_file_name: String) -> void:
	pass


func _create_snapshot() -> void:
	_snapshot = _game_state.duplicate(true)


func _reset_state() -> void:
	Stats.reset_to_default()
	Inventory.reset_to_default()
	_game_state = {}
	_snapshot = {}
