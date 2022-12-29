extends Control

enum Categories { CONSUMABLES, CURRENCY, KEY_ITEMS }

var _current_category = Categories.CONSUMABLES
var _slot = preload("res://interface/ui_inventory/slot.tscn")

@onready var _item_grid = %ItemGrid
@onready var _title: Label = $Title
@onready var _tooltips: Control = $Tooltips
@onready var _item_name: Label = %ItemName
@onready var _item_description: Label = %ItemDescription


func _ready() -> void:
	pass


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_inventory"):
		if owner.current_state != "Dead":
			_toggle_inventory()


func _update() -> void:
	match _current_category:
		Categories.CONSUMABLES:
			_title.text = "Consumables"
		Categories.CURRENCY:
			_title.text = "Currency"
		Categories.KEY_ITEMS:
			_title.text = "Key Items"


func _toggle_inventory() -> void:
	var new_pause_state = !get_tree().paused
	get_tree().paused = new_pause_state
	visible = new_pause_state


func _on_close_btn_pressed() -> void:
	_toggle_inventory()
	_current_category = Categories.CONSUMABLES
	_update()


func _on_left_btn_pressed() -> void:
	_current_category = wrapi(_current_category - 1, 0, 3)
	_update()


func _on_right_btn_pressed() -> void:
	_current_category = wrapi(_current_category + 1, 0, 3)
	_update()
