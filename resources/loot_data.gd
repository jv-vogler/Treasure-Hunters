class_name LootData
extends Resource

@export var _item: ItemData
@export var _quantity: int
@export_range(0, 100) var _drop_chance: int

var bonus: int:
	get:
		return GameStateManager.stats.luck


func roll_drops() -> Array:
	randomize()
	var loot = []

	for i in range(_quantity):
		var roll = randi_range(0, 100)
		if roll <= _drop_chance + bonus:
			loot.push_back(_item)

	return loot
