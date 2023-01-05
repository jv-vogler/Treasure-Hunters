extends Control

@onready var _option_1: CheckBox = $Panel/VBoxContainer/Option1
@onready var _option_2: CheckBox = $Panel/VBoxContainer/Option2
@onready var _option_3: CheckBox = $Panel/VBoxContainer/Option3


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_inventory"):
		_close_prompt()


func open_prompt() -> void:
	visible = true
	if GameStateManager.stats.max_health >= 175:
		_option_1.disabled = true
	if GameStateManager.stats.max_adrenaline >= 175:
		_option_2.disabled = true
	if GameStateManager.stats.max_poison >= 175:
		_option_3.disabled = true


func _close_prompt() -> void:
	visible = false


func _on_confirm_pressed() -> void:
	if _option_1.button_pressed:
		if GameStateManager.stats.max_health >= 175:
			_option_1.disabled = true
			return
		GameStateManager.stats.max_health += 25
		GameStateManager.inventory.remove_item("stat_potion", 1)
	elif _option_2.button_pressed:
		if GameStateManager.stats.max_adrenaline >= 175:
			_option_2.disabled = true
			return
		GameStateManager.stats.max_adrenaline += 25
		GameStateManager.stats.adrenaline_gain += 1
		GameStateManager.stats.adrenaline_decay -= 0.025
		GameStateManager.inventory.remove_item("stat_potion", 1)
	elif _option_3.button_pressed:
		if GameStateManager.stats.max_poison >= 175:
			_option_3.disabled = true
			return
		GameStateManager.stats.max_poison += 25
		GameStateManager.stats.poison_decay -= 0.01
		GameStateManager.inventory.remove_item("stat_potion", 1)

	_close_prompt()


func _on_cancel_pressed() -> void:
	_close_prompt()
