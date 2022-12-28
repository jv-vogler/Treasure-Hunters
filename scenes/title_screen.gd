extends Control


func _on_start_pressed() -> void:
	SceneManager.change_to(Scene.LEVEL_SELECTION, ["Fade Out", "Fade In"])


func _on_continue_pressed() -> void:
	pass # Replace with function body.


func _on_load_game_pressed() -> void:
	pass # Replace with function body.


func _on_settings_pressed() -> void:
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	get_tree().quit()
