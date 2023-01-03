extends Control

enum Currency { RUBY, EMERALD, DIAMOND }

const _health_potion_cost := [10, 3]
const _poison_bottle_cost := [20, 4]
const _stat_potion_cost := [100, 5]

var _coins_amount: int:
	set(value):
		_coins_amount = value
		_coins_amount_label.text = str(_coins_amount)
var _rubys_amount: int:
	set(value):
		_rubys_amount = value
		_rubys_amount_label.text = str(_rubys_amount)
var _emeralds_amount: int:
	set(value):
		_emeralds_amount = value
		_emeralds_amount_label.text = str(_emeralds_amount)
var _diamonds_amount: int:
	set(value):
		_diamonds_amount = value
		_diamonds_amount_label.text = str(_diamonds_amount)

var _health_potions_amount: int:
	set(value):
		_health_potions_amount = value
		_health_potions_label.text = str(_health_potions_amount)
var _poison_bottles_amount: int:
	set(value):
		_poison_bottles_amount = value
		_poison_bottles_label.text = str(_poison_bottles_amount)
var _stat_potions_amount: int:
	set(value):
		_stat_potions_amount = value
		_stat_potions_label.text = str(_stat_potions_amount)

var _total_coins: int = 0:
	set(value):
		_total_coins = value
		_total_coins_label.text = str(_total_coins)
		_total_coins_container.visible = true if _total_coins > 0 else false
var _total_rubys: int = 0:
	set(value):
		_total_rubys = value
		_total_rubys_label.text = str(_total_rubys)
		_total_rubys_container.visible = true if _total_rubys > 0 else false
var _total_emeralds: int = 0:
	set(value):
		_total_emeralds = value
		_total_emeralds_label.text = str(_total_emeralds)
		_total_emeralds_container.visible = true if _total_emeralds > 0 else false
var _total_diamonds: int = 0:
	set(value):
		_total_diamonds = value
		_total_diamonds_label.text = str(_total_diamonds)
		_total_diamonds_container.visible = true if _total_diamonds > 0 else false

var _scroll_x := 0.0

@onready var _coins_amount_label: Label = $CurrencyPanel/HBoxContainer/Coins/Label
@onready var _rubys_amount_label: Label = $CurrencyPanel/HBoxContainer/Rubys/Label
@onready var _emeralds_amount_label: Label = $CurrencyPanel/HBoxContainer/Emeralds/Label
@onready var _diamonds_amount_label: Label = $CurrencyPanel/HBoxContainer/Diamonds/Label

@onready var _health_potions_label: Label = $ShopPanel/VBoxContainer/PotionContainer/LabelAmount
@onready var _poison_bottles_label: Label = $ShopPanel/VBoxContainer/PoisonContainer/LabelAmount
@onready var _stat_potions_label: Label = $ShopPanel/VBoxContainer/StatPotionContainer/LabelAmount

@onready var _total_coins_container: HBoxContainer = $ShopPanel/VBoxContainer/Total/Coins
@onready var _total_coins_label: Label = $ShopPanel/VBoxContainer/Total/Coins/Label
@onready var _total_rubys_container: HBoxContainer = $ShopPanel/VBoxContainer/Total/Rubys
@onready var _total_rubys_label: Label = $ShopPanel/VBoxContainer/Total/Rubys/Label
@onready var _total_emeralds_container: HBoxContainer = $ShopPanel/VBoxContainer/Total/Emeralds
@onready var _total_emeralds_label: Label = $ShopPanel/VBoxContainer/Total/Emeralds/Label
@onready var _total_diamonds_container: HBoxContainer = $ShopPanel/VBoxContainer/Total/Diamonds
@onready var _total_diamonds_label: Label = $ShopPanel/VBoxContainer/Total/Diamonds/Label

@onready var _health_pots_inventory: Label = $InventoryPanel/HBoxContainer/HealthPot/Label
@onready var _poison_bottles_inventory: Label = $InventoryPanel/HBoxContainer/PoisonBottle/Label
@onready var _stat_potions_inventory: Label = $InventoryPanel/HBoxContainer/StatPotion/Label

@onready var _ship: Node2D = $Ship
@onready var _captain_clown_nose: AnimatedSprite2D = $TileMap/CaptainClownNose


func _ready() -> void:
	_init_scene()
	_load_currency()


func _process(delta: float) -> void:
	_scroll_x -= 20 * delta
	$ParallaxBackground.scroll_offset.x = _scroll_x


func _load_currency() -> void:
	_coins_amount = GameStateManager.inventory.get_quantity("gold_coin")
	_rubys_amount = GameStateManager.inventory.get_quantity("ruby")
	_emeralds_amount = GameStateManager.inventory.get_quantity("emerald")
	_diamonds_amount = GameStateManager.inventory.get_quantity("diamond")
	_health_pots_inventory.text = str(GameStateManager.inventory.get_quantity("health_potion"))
	_poison_bottles_inventory.text = str(GameStateManager.inventory.get_quantity("poison_bottle"))
	_stat_potions_inventory.text = str(GameStateManager.inventory.get_quantity("stat_potion"))


func _init_scene() -> void:
	$MouseBlocker.visible = true
	_animate_boat()
	await _animate_character(50, 1, 0.5)
	_captain_clown_nose.play("idle")
	$MouseBlocker.visible = false


func _animate_character(distance: int, x_scale: int, run_duration: float) -> void:
	var tween = create_tween()
	_captain_clown_nose.play("run")
	_captain_clown_nose.scale.x = x_scale
	tween.tween_property(_captain_clown_nose, "position:x", _captain_clown_nose.position.x + distance, run_duration)
	await get_tree().create_timer(run_duration/2).timeout


func _animate_boat() -> void:
	var tween = create_tween()
	tween.set_loops()
	tween.tween_property(_ship, "position:y", _ship.position.y + 2, 1.2)
	tween.parallel().tween_property(_ship, "rotation", 0.02, 0.7)
	tween.tween_property(_ship, "position:y", _ship.position.y - 2, 1.2)
	tween.parallel().tween_property(_ship, "rotation", -0.02, 0.7)


func _on_btn_level_selection_pressed() -> void:
	$MouseBlocker.visible = true
	await _animate_character(-50, -1, 0.7)
	SceneManager.change_to(Scene.LEVEL_SELECTION)


func _buy_items() -> void:
	if _health_potions_amount:
		GameStateManager.inventory.add_item("health_potion", _health_potions_amount)
		GameStateManager.inventory.remove_item("gold_coin", _total_coins)
		GameStateManager.inventory.remove_item("ruby", _total_rubys)
		_total_coins -= _health_potion_cost[0] * _health_potions_amount
		_total_rubys -= _health_potion_cost[1] * _health_potions_amount
		_health_potions_amount = 0
		_health_pots_inventory.text = str(GameStateManager.inventory.get_quantity("health_potion"))
	if _poison_bottles_amount:
		GameStateManager.inventory.add_item("poison_bottle", _poison_bottles_amount)
		GameStateManager.inventory.remove_item("gold_coin", _total_coins)
		GameStateManager.inventory.remove_item("emerald", _total_emeralds)
		_total_coins -= _poison_bottle_cost[0] * _poison_bottles_amount
		_total_emeralds -= _poison_bottle_cost[1] * _poison_bottles_amount
		_poison_bottles_amount = 0
		_poison_bottles_inventory.text = str(GameStateManager.inventory.get_quantity("poison_bottle"))
	if _stat_potions_amount:
		GameStateManager.inventory.add_item("stat_potion", _stat_potions_amount)
		GameStateManager.inventory.remove_item("gold_coin", _total_coins)
		GameStateManager.inventory.remove_item("diamond", _total_diamonds)
		_total_coins -= _stat_potion_cost[0] * _stat_potions_amount
		_total_diamonds -= _stat_potion_cost[1] * _stat_potions_amount
		_stat_potions_amount = 0
		_stat_potions_inventory.text = str(GameStateManager.inventory.get_quantity("stat_potion"))


func _increase_item(cost: Array, currency: Currency) -> void:
	_total_coins += cost[0]
	_coins_amount -= cost[0]

	match currency:
		Currency.RUBY:
			_total_rubys += cost[1]
			_rubys_amount -= cost[1]
		Currency.EMERALD:
			_total_emeralds += cost[1]
			_emeralds_amount -= cost[1]
		Currency.DIAMOND:
			_total_diamonds += cost[1]
			_diamonds_amount -= cost[1]


func _decrease_item(cost: Array, currency: Currency) -> void:
		_total_coins -= cost[0]
		_coins_amount += cost[0]

		match currency:
			Currency.RUBY:
				_total_rubys -= cost[1]
				_rubys_amount += cost[1]
			Currency.EMERALD:
				_total_emeralds -= cost[1]
				_emeralds_amount += cost[1]
			Currency.DIAMOND:
				_total_diamonds -= cost[1]
				_diamonds_amount += cost[1]


# HEALTH POTION
func _on_hp_decrease_pressed() -> void:
	if _health_potions_amount == 0:
		return
	_health_potions_amount -= 1
	_decrease_item(_health_potion_cost, Currency.RUBY)


func _on_hp_increase_pressed() -> void:
	if _coins_amount < _health_potion_cost[0] or _rubys_amount < _health_potion_cost[1]:
		return
	_health_potions_amount += 1
	_increase_item(_health_potion_cost, Currency.RUBY)


# POISON BOTTLE
func _on_pb_decrease_pressed() -> void:
	if _poison_bottles_amount == 0:
		return
	_poison_bottles_amount -= 1
	_decrease_item(_poison_bottle_cost, Currency.EMERALD)


func _on_pb_increase_pressed() -> void:
	if _coins_amount < _poison_bottle_cost[0] or _emeralds_amount < _poison_bottle_cost[1]:
		return
	_poison_bottles_amount += 1
	_increase_item(_poison_bottle_cost, Currency.EMERALD)


# STAT POTION
func _on_sp_decrease_pressed() -> void:
	if _stat_potions_amount == 0:
		return
	_stat_potions_amount -= 1
	_decrease_item(_stat_potion_cost, Currency.DIAMOND)


func _on_sp_increase_pressed() -> void:
	if _coins_amount < _stat_potion_cost[0] or _diamonds_amount < _stat_potion_cost[1]:
		return
	_stat_potions_amount += 1
	_increase_item(_stat_potion_cost, Currency.DIAMOND)


func _on_btn_confirm_pressed() -> void:
	_buy_items()
