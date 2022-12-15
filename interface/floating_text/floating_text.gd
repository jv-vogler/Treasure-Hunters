class_name FloatingText
extends Node2D

var type := "regular"
var pos: Vector2
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
			tween.tween_property(label, "position:x", randf_range(-30.0, 30.0), 1.5)
		"poison":
			label.label_settings = poison
			animation.play("Poison")


func delete() -> void:
	queue_free()
