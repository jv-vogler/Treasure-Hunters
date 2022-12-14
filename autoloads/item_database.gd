extends Node

var _database: Array[ItemData]


func _ready() -> void:
	var directory = DirAccess.open("res://resources/items/")
	directory.list_dir_begin()
	var filename = directory.get_next()
	while (filename):
		if !directory.current_is_dir():
			_database.append(load("res://resources/items/%s" % filename))
		filename = directory.get_next()
	directory.list_dir_end()


func get_item(item_id: String):
	for item in _database:
		if item.id == item_id:
			return item

	return null
