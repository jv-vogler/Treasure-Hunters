class_name Inventory
extends Resource

signal inventory_changed

@export var _inventory: Array[Dictionary]:
	set(new_inventory):
		_inventory = new_inventory
		emit_signal("inventory_changed")


func add_item(item_id: String, quantity := 1) -> void:
	if quantity <= 0:
		printerr("Can't add a negative number of items.")
		return

	var database_ref = ItemDatabase.get_item(item_id)
	if !database_ref:
		printerr("Could not find item.")
		return

	for item in _inventory:
		if item.item_ref != database_ref:
			continue

		item.quantity += quantity
		emit_signal("inventory_changed", self)


func remove_item(item_id: String, quantity := 1) -> void:
	if quantity <= 0:
		printerr("Can't remove a negative number of items.")
		return

	var database_ref = ItemDatabase.get_item(item_id)
	if !database_ref:
		printerr("Could not find item.")
		return

	for item in _inventory:
		if item.item_ref != database_ref:
			continue

		item.quantity = max(0, item.quantity - quantity)
		emit_signal("inventory_changed", self)


func get_quantity(item_id: String) -> int:
	for i in _inventory:
		if i.item_ref.id != item_id:
			continue
		return i.quantity

	return -1


func get_items() -> Array[Dictionary]:
	var item_list: Array[Dictionary] = []
	for i in _inventory:
		if i.quantity != 0:
			item_list.push_back({ "id": i.item_ref.id, "quantity": i.quantity })

	return item_list


func set_items(item_list: Array) -> void:
	reset_to_default()
	for item in item_list:
		add_item(item.id, item.quantity)


func reset_to_default() -> void:
	var default_inventory: Array[Dictionary] = []
	for i in ItemDatabase.consumables:
		default_inventory.push_back({ "item_ref": ItemDatabase.get_item(i), "quantity": 0 })

	for i in ItemDatabase.currency_items:
		default_inventory.push_back({ "item_ref": ItemDatabase.get_item(i), "quantity": 0 })

	for i in ItemDatabase.key_items:
		default_inventory.push_back({ "item_ref": ItemDatabase.get_item(i), "quantity": 0 })

	_inventory = default_inventory
