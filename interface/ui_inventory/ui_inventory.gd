extends Control

#@onready var _item_grid = $ItemPanel/ItemGrid
#@onready var _player: Player = owner


func _ready() -> void:
	pass


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_inventory"):
		_toggle_inventory()


func _toggle_inventory() -> void:
	var new_pause_state = !get_tree().paused
	get_tree().paused = new_pause_state
	visible = new_pause_state


func _on_slot_0_pressed() -> void:
	print('Used health pot')


func _on_slot_1_pressed() -> void:
	print('Used poison')


func _on_slot_2_pressed() -> void:
	print('Used stat potion')
