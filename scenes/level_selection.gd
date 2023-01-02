extends Control

var run_distance := 200
var run_duration := 0.6
var scroll_x := 0.0

@onready var captain_clown_nose: AnimatedSprite2D = $CaptainClownNose


func _process(delta: float) -> void:
	scroll_x -= 20 * delta
	$ParallaxBackground.scroll_offset.x = scroll_x


func _animate_character(distance: int, x_scale: int) -> void:
	$MouseBlocker.visible = true
	var tween = create_tween()
	captain_clown_nose.play("run")
	captain_clown_nose.scale.x = x_scale
	tween.tween_property(captain_clown_nose, "position:x", captain_clown_nose.position.x + distance, 2.5)
	await get_tree().create_timer(run_duration).timeout


func _on_btn_title_screen_pressed() -> void:
	await _animate_character(-run_distance, -1)
	SceneManager.change_to(Scene.TITLE_SCREEN)


func _on_btn_shop_pressed() -> void:
	await _animate_character(run_distance, 1)
	SceneManager.change_to(Scene.SHOP)
