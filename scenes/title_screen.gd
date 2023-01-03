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
	if "autosave.sav" in save_files:
		_continue.visible = true
	if save_files != []:
		_load_game.disabled = false


func _on_continue_pressed() -> void:
	GameStateManager.load_file("autosave")
	SceneManager.change_to(Scene.LEVEL_SELECTION)


func _on_new_game_pressed() -> void:
	SceneManager.change_to(Scene.LEVEL_SELECTION)


func _on_load_game_pressed() -> void:
	pass # Replace with function body.


func _on_settings_pressed() -> void:
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	get_tree().quit()
