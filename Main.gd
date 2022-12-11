class_name Game
extends Node2D


func _ready() -> void:
	debugger_setup()


func debugger_setup() -> void:
	Debugger.add_stat("Poison", $Player, "current_poison")
	Debugger.add_stat("Adrenaline", $Player, "current_adrenaline")
#	Debugger.add_stat("Buffs", $Player, "buffs")
#	Debugger.add_stat("FierceStatus", $FierceTooth, "status")
	Debugger.add_stat("FierceVel", $FierceTooth, "velocity")
	Debugger.add_stat("is_on_wall", $FierceTooth, "is_on_wall", true)
	Debugger.add_stat("Fierce1State", $FierceTooth/StateMachine, "current_state")
	pass
