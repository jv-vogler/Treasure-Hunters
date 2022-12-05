class_name Game
extends Node2D


func _ready() -> void:
	debugger_setup()


func debugger_setup() -> void:
#	Debugger.add_stat("Player state", $Player/StateMachine, "current_state")
	Debugger.add_stat("FierceTooth state", $FierceTooth/StateMachine, "current_state")
	Debugger.add_stat("FierceTooth stagger count", $FierceTooth, "stagger_count")
	Debugger.add_stat("FierceTooth staggerable", $FierceTooth, "staggerable")
