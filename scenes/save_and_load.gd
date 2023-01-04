extends Control

var loading := true
var _target_file_name: String = ""
var _slot_scene = preload("res://scenes/save_slot.tscn")
var _placeholder_name: String

@onready var _slots_container: VBoxContainer = $ScrollContainer/VBoxContainer/SlotsContainer
@onready var _title: Label = $Title
@onready var _delete_label: Label = $Popup/DeletePrompt/Label
@onready var _overwrite_label: Label = $Popup/OverwritePrompt/Label
@onready var _line_edit: LineEdit = $Popup/SavePrompt/HBoxContainer/LineEdit


func _ready() -> void:
	if loading:
		_title.text = "Load Game"
	else:
		_title.text = "Save Game"
		%EmptySlot.visible = true
	_update()


func _update() -> void:
	_close_popup()
	_line_edit.text = ""
	if GameStateManager.get_save_names() != []:
		_clear_slots()
		_populate_save_files()
	else:
		_clear_slots()
		%NoSaves.visible = true


func _populate_save_files() -> void:
	var _sorted_array := []
	var save_files = GameStateManager.get_saves_metadata()

	for unix_time in save_files:
		_sorted_array.push_back(unix_time)

	_sorted_array.sort()
	_sorted_array.reverse()

	for unix_time in _sorted_array:
		var slot = _slot_scene.instantiate()
		slot.save_name = save_files[unix_time]["name"]
		slot.levels_unlocked = save_files[unix_time]["levels_unlocked"]
		slot.currency = save_files[unix_time]["currency"]
		slot.timestamp = Time.get_datetime_dict_from_unix_time(unix_time)

		if loading:
			slot.connect("delete_pressed", Callable(self, "_on_delete_pressed"))
		else:
			slot.connect("overwrite_pressed", Callable(self, "_on_overwrite_pressed"))

		_slots_container.add_child(slot)


func _clear_slots() -> void:
	var slots = _slots_container.get_children()
	for slot in slots:
		slot.queue_free()


func _set_placeholder_text() -> void:
	var save_names = GameStateManager.get_save_names()
	_placeholder_name = "save1.sav"

	for i in range(save_names.size()):
		if _placeholder_name in save_names:
			var number = int(_placeholder_name.trim_prefix("save").trim_suffix(".sav"))
			_placeholder_name = "save%s.sav" % [number + 1]

	_line_edit.placeholder_text = " " + _placeholder_name.trim_suffix(".sav").capitalize()


func _is_name_taken(file_name: String) -> bool:
	var save_names = GameStateManager.get_save_names()
	for save_name in save_names:
		if save_name == file_name + ".sav":
			return true

	return false


func _close_popup() -> void:
	$Popup/DeletePrompt.visible = false
	$Popup/SavePrompt.visible = false
	$Popup/OverwritePrompt.visible = false
	$Popup.visible = false


func _on_title_screen_pressed() -> void:
	SceneManager.change_to(Scene.TITLE_SCREEN)


func _on_overwrite_pressed(save_name: String) -> void:
	_target_file_name = save_name
	_overwrite_label.text = "Overwrite %s?" % save_name.capitalize()
	$Popup.visible = true
	$Popup/OverwritePrompt.visible = true


func _on_delete_pressed(save_name: String) -> void:
	_target_file_name = save_name
	_delete_label.text = "Delete %s permanently?" % save_name.capitalize()
	$Popup.visible = true
	$Popup/DeletePrompt.visible = true


func _on_empty_slot_pressed() -> void:
	_set_placeholder_text()
	$Popup.visible = true
	$Popup/SavePrompt.visible = true


func _on_confirm_delete_pressed() -> void:
	GameStateManager.delete_file(_target_file_name)
	_target_file_name = ""
	_update()


func _on_confirm_overwrite_pressed() -> void:
	GameStateManager.save_file(_target_file_name)
	_target_file_name = ""
	_update()


func _on_confirm_save_pressed() -> void:
	if _line_edit.text == "":
		var save_name = _placeholder_name.trim_suffix(".sav").to_lower()
		if !save_name.is_valid_filename():
			printerr("Invalid file name")
			_close_popup()
			return

		GameStateManager.save_file(save_name)
		_update()
		return

	if !_is_name_taken(_line_edit.text):
		if !_line_edit.text.is_valid_filename():
			printerr("Invalid file name")
			_close_popup()
			return

		GameStateManager.save_file(_line_edit.text)
		_update()
		return

	_on_overwrite_pressed(_line_edit.text)


func _on_cancel_pressed() -> void:
	_close_popup()
