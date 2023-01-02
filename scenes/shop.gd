extends Control

var scroll_x := 0.0

@onready var ship: Node2D = $Ship
@onready var captain_clown_nose: AnimatedSprite2D = $TileMap/CaptainClownNose


func _ready() -> void:
	$MouseBlocker.visible = true
	_animate_boat()
	await _animate_character(50, 1, 0.5)
	captain_clown_nose.play("idle")
	$MouseBlocker.visible = false


func _process(delta: float) -> void:
	scroll_x -= 20 * delta
	$ParallaxBackground.scroll_offset.x = scroll_x


func _animate_character(distance: int, x_scale: int, run_duration: float) -> void:
	var tween = create_tween()
	captain_clown_nose.play("run")
	captain_clown_nose.scale.x = x_scale
	tween.tween_property(captain_clown_nose, "position:x", captain_clown_nose.position.x + distance, run_duration)
	await get_tree().create_timer(run_duration/2).timeout


func _animate_boat() -> void:
	var tween = create_tween()
	tween.set_loops()
	tween.tween_property(ship, "position:y", ship.position.y + 2, 1.2)
	tween.parallel().tween_property(ship, "rotation", 0.02, 0.7)
	tween.tween_property(ship, "position:y", ship.position.y - 2, 1.2)
	tween.parallel().tween_property(ship, "rotation", -0.02, 0.7)


func _on_btn_level_selection_pressed() -> void:
	$MouseBlocker.visible = true
	await _animate_character(-50, -1, 0.7)
	SceneManager.change_to(Scene.LEVEL_SELECTION)
