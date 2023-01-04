class_name SaveSlot
extends Button

signal delete_pressed
signal overwrite_pressed

var save_name: String
var levels_unlocked: Array
var currency: Dictionary
var timestamp: Dictionary
var _loading: bool:
	get:
		return get_parent().owner.loading

@onready var _coins_label: Label = $Currency/Coins/Label
@onready var _rubys_label: Label = $Currency/Rubys/Label
@onready var _emeralds_label: Label = $Currency/Emeralds/Label
@onready var _diamonds_label: Label = $Currency/Diamonds/Label
@onready var _metadata: Label = $Metadata


func _ready() -> void:
	if !_loading:
		$DeleteSaveBtn.visible = false

	text = save_name.capitalize()
	$FileName.text = save_name + ".sav"
	_coins_label.text = str(currency["gold_coin"])
	_rubys_label.text = str(currency["ruby"])
	_emeralds_label.text = str(currency["emerald"])
	_diamonds_label.text = str(currency["diamond"])
	_metadata.text = "Level %s\n%s/%s/%s\n%s:%s:%s" % [
		str(levels_unlocked.size() - 1),
		str(timestamp.day).pad_zeros(2), str(timestamp.month).pad_zeros(2), str(timestamp.year),
		str(timestamp.hour).pad_zeros(2), str(timestamp.minute).pad_zeros(2), str(timestamp.second).pad_zeros(2)
	]


func _on_delete_save_pressed() -> void:
	emit_signal("delete_pressed", save_name)


func _on_pressed() -> void:
	if _loading:
		GameStateManager.load_file(save_name)
		SceneManager.change_to(Scene.LEVEL_SELECTION)
	else:
		emit_signal("overwrite_pressed", save_name)
