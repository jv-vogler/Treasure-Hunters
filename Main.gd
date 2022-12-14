class_name Game
extends Control


func _ready() -> void:
	SceneManager.change_to(Scene.TITLE_SCREEN, "", "Fade In")
