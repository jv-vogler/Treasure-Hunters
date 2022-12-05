class_name Game
extends Node2D


func _ready() -> void:
	debugger_setup()

#
#func _physics_process(delta: float) -> void:
#	print($Player/StateMachine.current_state)


func debugger_setup() -> void:
	Debugger.add_stat("Player state", $Player/StateMachine, "current_state")
#	Debugger.add_stat("combo1", $Player/StateMachine/Attack1, "combo")
	Debugger.add_stat("is_hurt1", $Player/StateMachine/Attack1, "is_hurt")
#	Debugger.add_stat("combo2", $Player/StateMachine/Attack2, "combo")
	Debugger.add_stat("is_hurt2", $Player/StateMachine/Attack2, "is_hurt")
#	Debugger.add_stat("combo3", $Player/StateMachine/Attack3, "combo")
	Debugger.add_stat("is_hurt3", $Player/StateMachine/Attack3, "is_hurt")
