class_name FloatingText
extends Node2D

const SPREAD = 50.0

var type := "regular"
var regular = preload("res://interface/floating_text/regular.tres")
var poison = preload("res://interface/floating_text/poison.tres")


@onready var label: Label = $Label
@onready var animation: AnimationPlayer = $Animation
@onready var text: String


func _ready() -> void:
	randomize()
	label.text = text

	match type:
		"regular":
			label.label_settings = regular
			animation.play("Fade Up")
			var tween = create_tween()
			tween.tween_property(label, "position:x", randf_range(-SPREAD, SPREAD), 1.5)
		"poison":
			label.label_settings = poison
			animation.play("Poison")


func delete() -> void:
	queue_free()
