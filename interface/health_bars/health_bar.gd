class_name HealthBar
extends Control

@onready var hp = $Health
@onready var dmg = $Damage


func update(health: int):
	hp.value = health
	var tween = create_tween().set_trans(Tween.TRANS_CIRC)
	tween.tween_property(dmg, "value", hp.value, 0.75)
