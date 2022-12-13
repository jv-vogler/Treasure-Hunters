class_name ItemData
extends Resource

enum ItemType { CONSUMABLE, KEY, CURRENCY }

@export var id := ""
@export var icon: Texture
@export var animated_texture: AnimatedTexture

@export var display_name := ""
@export var description := ""

@export var display_name_pt := ""
@export var description_pt := ""

@export var type: ItemType
@export var sell_value: int
