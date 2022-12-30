extends Control

signal used_health_potion
signal used_poison_bottle
signal used_stat_potion

enum Categories { CONSUMABLES, CURRENCY, KEY_ITEMS }

var _current_category = Categories.CONSUMABLES

@onready var _item_grid = %ItemGrid
@onready var _title: Label = $Title

@onready var _tooltips: Control = $Tooltips
@onready var _item_name: Label = %ItemName
@onready var _item_description: Label = %ItemDescription


func _ready() -> void:
	GameStateManager.inventory.connect("inventory_changed", Callable(self, "_on_inventory_changed"))
	for slot in _item_grid.get_children():
		var slot_number = str(slot.name).trim_prefix("Slot")
		slot.connect("mouse_entered", Callable(self, "_on_slot%s_mouse_entered" % [slot_number]))
		slot.connect("mouse_exited", Callable(self, "_on_slot_mouse_exited"))
		slot.get_node("Btn").connect("pressed", Callable(self, "_on_btn%s_pressed" % [slot_number]))


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_inventory"):
		if owner.current_state != "Dead":
			_toggle_inventory()

	if visible:
		if event.is_action_pressed("ui_left"):
			_on_left_btn_pressed()
		if event.is_action_pressed("ui_right"):
			_on_right_btn_pressed()


func _update() -> void:
	var inventory: Dictionary = GameStateManager.inventory.get_items_categorized()
	var slots: Array = _item_grid.get_children()
	var dict_key: String

	match _current_category:
		Categories.CONSUMABLES:
			_title.text = "Consumables"
			dict_key = "consumables"
		Categories.CURRENCY:
			_title.text = "Currency"
			dict_key = "currency"
		Categories.KEY_ITEMS:
			_title.text = "Key Items"
			dict_key = "key_items"

	_item_grid.visible = false
	_item_grid.visible = true

	for slot in slots:
		slot.reset()

	for i in range(inventory[dict_key].size()):
		slots[i].item_ref = inventory[dict_key][i].item_ref
		slots[i].quantity = inventory[dict_key][i].quantity
		slots[i].update()


func _toggle_inventory() -> void:
	_current_category = Categories.CONSUMABLES
	var new_pause_state = !get_tree().paused
	get_tree().paused = new_pause_state
	visible = new_pause_state
	_update()


func _use_item(item_id: String) -> void:
	match item_id:
		"health_potion":
			emit_signal("used_health_potion")
		"poison_bottle":
			emit_signal("used_poison_bottle")
		"stat_potion":
			emit_signal("used_stat_potion")


func _on_inventory_changed() -> void:
	_update()


func _on_close_btn_pressed() -> void:
	_toggle_inventory()
	_update()


func _on_left_btn_pressed() -> void:
	_tooltips.visible = false
	_current_category = wrapi(_current_category - 1, 0, 3)
	_update()


func _on_right_btn_pressed() -> void:
	_tooltips.visible = false
	_current_category = wrapi(_current_category + 1, 0, 3)
	_update()


func _on_slot1_mouse_entered() -> void:
	if %Slot1.item_ref:
		_item_name.text = %Slot1.item_ref.display_name
		_item_description.text = %Slot1.item_ref.description
		_tooltips.visible = true


func _on_slot2_mouse_entered() -> void:
	if %Slot2.item_ref:
		_item_name.text = %Slot2.item_ref.display_name
		_item_description.text = %Slot2.item_ref.description
		_tooltips.visible = true


func _on_slot3_mouse_entered() -> void:
	if %Slot3.item_ref:
		_item_name.text = %Slot3.item_ref.display_name
		_item_description.text = %Slot3.item_ref.description
		_tooltips.visible = true


func _on_slot4_mouse_entered() -> void:
	if %Slot4.item_ref:
		_item_name.text = %Slot4.item_ref.display_name
		_item_description.text = %Slot4.item_ref.description
		_tooltips.visible = true


func _on_slot5_mouse_entered() -> void:
	if %Slot5.item_ref:
		_item_name.text = %Slot5.item_ref.display_name
		_item_description.text = %Slot5.item_ref.description
		_tooltips.visible = true


func _on_slot6_mouse_entered() -> void:
	if %Slot6.item_ref:
		_item_name.text = %Slot6.item_ref.display_name
		_item_description.text = %Slot6.item_ref.description
		_tooltips.visible = true


func _on_slot_mouse_exited() -> void:
	_tooltips.visible = false


func _on_btn1_pressed() -> void:
	if _current_category == Categories.CONSUMABLES and %Slot1.item_ref:
		_use_item(%Slot1.item_ref.id)


func _on_btn2_pressed() -> void:
	if _current_category == Categories.CONSUMABLES and %Slot2.item_ref:
		_use_item(%Slot2.item_ref.id)


func _on_btn3_pressed() -> void:
	if _current_category == Categories.CONSUMABLES and %Slot3.item_ref:
		_use_item(%Slot3.item_ref.id)


func _on_btn4_pressed() -> void:
	if _current_category == Categories.CONSUMABLES and %Slot4.item_ref:
		_use_item(%Slot4.item_ref.id)


func _on_btn5_pressed() -> void:
	if _current_category == Categories.CONSUMABLES and %Slot5.item_ref:
		_use_item(%Slot5.item_ref.id)


func _on_btn6_pressed() -> void:
	if _current_category == Categories.CONSUMABLES and %Slot6.item_ref:
		_use_item(%Slot6.item_ref.id)
