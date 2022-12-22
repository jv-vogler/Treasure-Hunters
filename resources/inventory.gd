class_name Inventory
extends Resource

signal inventory_changed

@export var inventory: Array[Dictionary] = [
	{ "ref": ItemDatabase.get_item("health_potion"), "quantity": 0 },
	{ "ref": ItemDatabase.get_item("poison_bottle"), "quantity": 0 },
	{ "ref": ItemDatabase.get_item("stat_potion"), "quantity": 0 },
]:
	get:
		return inventory
	set(new_inventory):
		inventory = new_inventory
		emit_signal("inventory_changed", self)


func add_item(item_id: String, quantity := 1):
	if quantity <= 0:
		printerr("Can't add a negative number of items.")

	var item_ref = ItemDatabase.get_item(item_id)
	if !item_ref:
		printerr("Could not find item.")
		return

	for item in inventory:
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

	for item in inventory:
		if item.ref != item_ref:
			continue

		item.quantity = max(0, item.quantity - quantity)
		emit_signal("inventory_changed", self)


func get_item(index):
	return inventory[index]


func get_items():
	var items = []
	for i in inventory:
		var item = { i.ref.id: i.quantity }
		items.push_back(item)

	return items


func reset_to_default() -> void:
	inventory = [
	{ "ref": ItemDatabase.get_item("health_potion"), "quantity": 0 },
	{ "ref": ItemDatabase.get_item("poison_bottle"), "quantity": 0 },
	{ "ref": ItemDatabase.get_item("stat_potion"), "quantity": 0 },
]
