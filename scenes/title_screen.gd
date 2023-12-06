extends Control

@onready var _continue: Button = $Buttons/Continue
@onready var _new_game: Button = $Buttons/NewGame
@onready var _load_game: Button = $Buttons/LoadGame


func _ready() -> void:
	GameStateManager.reset_state()
	_check_saves()
	_continue.grab_focus() if _continue.visible else _new_game.grab_focus()


func _check_saves() -> void:
	var save_files = GameStateManager.get_save_names()
	if save_files != []:
		_continue.visible = true
		_load_game.disabled = false


func _on_continue_pressed() -> void:
	var most_recent_save_name: String

	var _sorted_array := []
	var save_files = GameStateManager.get_saves_metadata()

	for unix_time in save_files:
		_sorted_array.push_back(unix_time)

	_sorted_array.sort()
	_sorted_array.reverse()
	most_recent_save_name = save_files[_sorted_array[0]]["name"]

	GameStateManager.load_file(most_recent_save_name)
	SceneManager.change_to(Scene.LEVEL_SELECTION)


func _on_new_game_pressed() -> void:
#	SceneManager.change_to(Scene.LEVEL_SELECTION)
	SceneManager.change_to(Scene.TEST_LEVEL)



func _on_load_game_pressed() -> void:
	SceneManager.change_to(Scene.SAVE_LOAD)


func _on_settings_pressed() -> void:
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	get_tree().quit()
