class_name Slot
extends Control

var item_ref: ItemData
var quantity: int

@onready var _item_texture = $ItemTexture
@onready var _quantity = $Quantity


func _ready() -> void:
	update()


func update() -> void:
	if item_ref and quantity:
		_item_texture.texture = item_ref.icon
		_quantity.text = str(quantity)
	else:
		_item_texture.texture = null
		_quantity.text = ""


func reset() -> void:
	item_ref = null
	quantity = 0
	update()
