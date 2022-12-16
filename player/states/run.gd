extends PlayerMoveState

@export var first_attack_node: NodePath
@export var state_machine_node: NodePath
@export var hurt_node: NodePath
@export var animation: String = ""

var _run_dust = preload("res://player/particles/run_dust.tscn")

@onready var attack_state: BaseState = get_node(first_attack_node)
@onready var state_machine: Node = get_node(state_machine_node)
@onready var hurt_state: BaseState = get_node(hurt_node)


func enter() -> void:
	super()
	$DustTimer.start()

	if state_machine.previous_state == fall_state:
		player.animations.play("Sword_Ground")
		await player.animations.animation_finished
	player.animations.play(animation)


func exit() -> void:
	$DustTimer.stop()


func input(event: InputEvent) -> BaseState:
	if Input.is_action_just_pressed("attack"):
		return attack_state

	var new_state = super.input(event)
	if new_state:
		return new_state

	return null


func physics_process(delta: float) -> BaseState:
	if is_hurt:
		return hurt_state

	var new_state = super.physics_process(delta)
	if new_state:
		return new_state

	return null


func _on_player_took_damage() -> void:
	is_hurt = true


func _on_dust_timer_timeout() -> void:
	var dust = _run_dust.instantiate()
	dust.scale = player.sprite.scale
	dust.sprite_offset.x -= 10 * dust.scale.x
	player.add_child(dust)
	$DustTimer.start()
