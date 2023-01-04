extends Control

var _run_distance := 200
var _run_duration := 0.6
var _scroll_x := 0.0

@onready var _captain_clown_nose: AnimatedSprite2D = $CaptainClownNose
@onready var _level_selection_map: Panel = $LevelSelectionMap


func _ready() -> void:
	_unlock_levels()


func _process(delta: float) -> void:
	_scroll_x -= 20 * delta
	$ParallaxBackground.scroll_offset.x = _scroll_x


func _unlock_levels() -> void:
	for level in GameStateManager.levels_unlocked:
		match level:
			"res://levels/level_2.tscn":
				_level_selection_map.get_node("Level2").disabled = false
			"res://levels/level_3.tscn":
				_level_selection_map.get_node("Level3").disabled = false
			"res://levels/level_4.tscn":
				_level_selection_map.get_node("Level4").disabled = false
			"res://levels/level_5.tscn":
				_level_selection_map.get_node("Level5").disabled = false
			"res://levels/level_6.tscn":
				_level_selection_map.get_node("Level6").disabled = false
			"res://levels/level_7.tscn":
				_level_selection_map.get_node("Level7").disabled = false
			"res://levels/level_8.tscn":
				_level_selection_map.get_node("Level8").disabled = false
			"res://levels/level_9.tscn":
				_level_selection_map.get_node("Level9").disabled = false
			"res://levels/level_10.tscn":
				_level_selection_map.get_node("Level10").disabled = false


func _animate_character(distance: int, x_scale: int) -> void:
	$MouseBlocker.visible = true
	var tween = create_tween()
	_captain_clown_nose.play("run")
	_captain_clown_nose.scale.x = x_scale
	tween.tween_property(_captain_clown_nose, "position:x", _captain_clown_nose.position.x + distance, 2.5)
	await get_tree().create_timer(_run_duration).timeout


func _on_btn_title_screen_pressed() -> void:
	await _animate_character(-_run_distance, -1)
	SceneManager.change_to(Scene.TITLE_SCREEN)


func _on_btn_shop_pressed() -> void:
	await _animate_character(_run_distance, 1)
	SceneManager.change_to(Scene.SHOP)
