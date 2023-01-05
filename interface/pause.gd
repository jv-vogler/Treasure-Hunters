extends Control

@onready var _ui_inventory: Control = $"../UIInventory"


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_toggle_pause()


func _toggle_pause() -> void:
	if _ui_inventory.visible and !visible:
		visible = true
		return

	if _ui_inventory.visible and visible:
		visible = false
		return

	var new_pause_state = !get_tree().paused
	get_tree().paused = new_pause_state
	visible = new_pause_state


func _on_resume_pressed() -> void:
	_toggle_pause()


func _on_quit_pressed() -> void:
	get_tree().paused = false
	SceneManager.change_to(Scene.TITLE_SCREEN)
