class_name HUD
extends Control

var _adrenaline_ready = preload("res://interface/health_bars/adrenaline_full.tres")

@onready var _health_bar: ResourceBar = $HealthBar
@onready var _adrenaline_bar: ResourceBar = $AdrenalineBar
@onready var _poison_bar: ResourceBar = $PoisonBar
@onready var _coins_label: Label = $Coins/Amount


func _ready() -> void:
	GameStateManager.inventory.connect("inventory_changed", Callable(self, "_on_inventory_changed"))


func _update_bar(bar: ResourceBar, current_value: int, max_value: int) -> void:
	var new_value_percent = Utils.get_percent(current_value, max_value)
	bar.update(new_value_percent)


func _on_player_health_changed(current_health: int, max_health: int) -> void:
	_update_bar(_health_bar, current_health, max_health)


func _on_player_adrenaline_changed(current_adrenaline: int, max_adrenaline: int) -> void:
	_update_bar(_adrenaline_bar, current_adrenaline, max_adrenaline)

	if current_adrenaline == max_adrenaline:
		_adrenaline_bar.progress.set_material(_adrenaline_ready)
	else:
		_adrenaline_bar.progress.set_material(null)


func _on_player_poison_changed(current_poison: int, max_poison: int) -> void:
	_update_bar(_poison_bar, current_poison, max_poison)


func _on_inventory_changed() -> void:
	var coins = GameStateManager.inventory.get_quantity("gold_coin")
	_coins_label.text = str(coins)
