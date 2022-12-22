extends Node

enum ItemType { CONSUMABLE, KEY, CURRENCY }

var all_items: Array[String]
var consumables: Array[String]
var key_items: Array[String]
var currency_items: Array[String]
var _database: Array[ItemData]


func _ready() -> void:
	var directory = DirAccess.open("res://resources/items/")
	directory.list_dir_begin()
	var filename = directory.get_next()
	while (filename):
		if !directory.current_is_dir():
			var item = load("res://resources/items/%s" % filename)
			_categorize_item(item)
			_database.append(item)
		filename = directory.get_next()
	directory.list_dir_end()


func get_item(item_id: String) -> ItemData:
	for item in _database:
		if item.id == item_id:
			return item
	return null


func _categorize_item(item: ItemData) -> void:
	all_items.push_back(item.id)
	if item.type == ItemType.CONSUMABLE:
		consumables.push_back(item.id)
	elif item.type == ItemType.KEY:
		key_items.push_back(item.id)
	elif item.type == ItemType.CURRENCY:
		currency_items.push_back(item.id)
