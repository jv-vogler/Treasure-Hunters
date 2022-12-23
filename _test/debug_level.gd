extends Node2D

#@onready var _save: Button = $Save
#@onready var _load: Button = $Load

@onready var add_item: Button = $AddItem
@onready var remove_item: Button = $RemoveItem

@onready var inventory: Label = $Inventory
@onready var game_state: Label = $GameState


func _ready() -> void:
	_update()


func _process(_delta: float) -> void:
	pass


func _update() -> void:
#	inventory.text = str(GameStateManager.inventory._inventory)
	inventory.text = str(GameStateManager._game_state)


func _on_save_pressed() -> void:
	GameStateManager.save_file("debug")
	_update()


func _on_load_pressed() -> void:
	GameStateManager.load_file("debug")
	_update()


func _on_add_item_pressed() -> void:
	GameStateManager.inventory.add_item("health_potion", 1)
	_update()


func _on_remove_item_pressed() -> void:
	GameStateManager.inventory.remove_item("health_potion", 1)
	_update()