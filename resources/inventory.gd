class_name Inventory
extends Resource

signal inventory_changed

@export var _inventory: Array[Dictionary] = [
	{ "ref": ItemDatabase.get_item("health_potion"), "quantity": 0 },
	{ "ref": ItemDatabase.get_item("poison_bottle"), "quantity": 0 },
	{ "ref": ItemDatabase.get_item("stat_potion"), "quantity": 0 },
]:
	get:
		return _inventory
	set(new_inventory):
		_inventory = new_inventory
		emit_signal("inventory_changed", self)


func add_item(item_id: String, quantity := 1):
	if quantity <= 0:
		printerr("Can't add a negative number of items.")

	var item_ref = ItemDatabase.get_item(item_id)
	if !item_ref:
		printerr("Could not find item.")
		return

	for item in _inventory:
		if item.ref != item_ref:
			continue

		item.quantity += quantity
		emit_signal("inventory_changed", self)


func remove_item(item_id: String, quantity := 1):
	if quantity <= 0:
		printerr("Can't remove a negative number of items.")

	var item_ref = ItemDatabase.get_item(item_id)
	if !item_ref:
		printerr("Could not find item.")
		return

	for item in _inventory:
		if item.ref != item_ref:
			continue

		item.quantity = max(0, item.quantity - quantity)
		emit_signal("inventory_changed", self)


func get_item(index):
	return _inventory[index]
