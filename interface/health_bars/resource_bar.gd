class_name ResourceBar
extends TextureProgressBar

@onready var recoil = $Recoil
@onready var progress = $Progress


func update(_value: int):
	var tween = create_tween()
	tween.tween_property(progress, "value", _value, 0.1).set_trans(Tween.TRANS_LINEAR)
