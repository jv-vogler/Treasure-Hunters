class_name Inventory
extends Resource

signal inventory_changed

@export var inventory: Array[Dictionary] = []


func add_item(item_id: String, quantity := 1):
	if quantity <= 0:
		printerr("Can't add a negative number of items.")
		return

	var database_ref = ItemDatabase.get_item(item_id)
	if !database_ref:
		printerr("Could not find item.")
		return

	for item in inventory:
		if item.id != database_ref:
			continue

		item.quantity += quantity
		emit_signal("inventory_changed", self)


func remove_item(item_id: String, quantity := 1):
	if quantity <= 0:
		printerr("Can't remove a negative number of items.")
		return

	var database_ref = ItemDatabase.get_item(item_id)
	if !database_ref:
		printerr("Could not find item.")
		return

	for item in inventory:
		if item.id != database_ref:
			continue

		item.quantity = max(0, item.quantity - quantity)
		emit_signal("inventory_changed", self)


func get_item(index):
	return ItemDatabase.get_item(inventory[index].id)


func reset_to_default() -> void:
	inventory = [
	{ "id": "health_potion", "quantity": 0 },
	{ "id": "poison_bottle", "quantity": 0 },
	{ "id": "stat_potion", "quantity": 0 },
]

	for item in ItemDatabase.currency_items:
		inventory.push_back({ "id": item, "quantity": 0 })

	for item in ItemDatabase.key_items:
		inventory.push_back({ "id": item, "quantity": 0 })
