extends Level

var fierce_tooth = preload("res://enemies/fierce_tooth/fierce_tooth.tscn")
var switch: bool = false

@onready var player: Player = $Player
@onready var enemies: Node2D = $Enemies
@onready var enemy_spawner_1: Marker2D = $Enemies/EnemySpawner1
@onready var enemy_spawner_2: Marker2D = $Enemies/EnemySpawner2
@onready var enemy_spawner_3: Marker2D = $Enemies/EnemySpawner3
@onready var detection_1: Area2D = $Enemies/Detection1
@onready var timer: Timer = $Timer


func _ready() -> void:
	if props.checkpoint:
		$Checkpoint.queue_free()
		$Player.global_position = props.checkpoint


func _spawn_enemy() -> void:
	var e
	if !switch:
		e = fierce_tooth.instantiate()
		e.global_position = enemy_spawner_1.global_position
		e.position.x += randf_range(-5.0, 5.0)
		enemies.add_child(e)
		e = fierce_tooth.instantiate()
		e.global_position = enemy_spawner_2.global_position
		e.position.x += randf_range(-5.0, 5.0)
		enemies.add_child(e)
		e = fierce_tooth.instantiate()
		e.global_position = enemy_spawner_3.global_position
		e.position.x += randf_range(-5.0, 5.0)
		enemies.add_child(e)
		switch = true

	timer.start(randf_range(5.0, 10.0))
	await timer.timeout

	e = fierce_tooth.instantiate()
	e.global_position = enemy_spawner_1.global_position
	e.position.x += randf_range(-5.0, 5.0)
	enemies.add_child(e)
	e = fierce_tooth.instantiate()
	e.global_position = enemy_spawner_2.global_position
	e.position.x += randf_range(-5.0, 5.0)
	enemies.add_child(e)
	e = fierce_tooth.instantiate()
	e.global_position = enemy_spawner_3.global_position
	e.position.x += randf_range(-5.0, 5.0)
	enemies.add_child(e)
	_spawn_enemy()


func _on_detection_1_body_entered(body: Player) -> void:
	if !body:
		return
	_spawn_enemy()
	detection_1.queue_free()


func _on_checkpoint_body_entered(body: Player) -> void:
	if !body:
		return

	GameStateManager.save_file("autosave")
	props.checkpoint = $Player.global_position
	$Checkpoint.queue_free()



func _on_potion_body_entered(body: Player) -> void:
	if !body:
		return
	player._restore_health()
