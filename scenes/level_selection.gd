extends Control


func _on_to_title_screen_pressed() -> void:
	SceneManager.change_to(Scene.TITLE_SCREEN, "Fade Out", "Fade In")


func _on_test_level_pressed() -> void:
	SceneManager.change_to(Scene.TEST_LEVEL, "Fade Out", "Fade In")
