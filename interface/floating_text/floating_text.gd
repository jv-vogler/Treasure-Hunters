class_name FloatingText
extends Node2D

@onready var label: Label = $Label
@onready var animation: AnimationPlayer = $Animation
@onready var text: String


func _ready() -> void:
	label.text = text
	animation.play("Fade Up")


func delete() -> void:
	queue_free()
