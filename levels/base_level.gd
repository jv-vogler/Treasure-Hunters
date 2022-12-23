class_name Level
extends Node2D

signal props_changed

@export var props: Dictionary:
	set(new_props):
		props = new_props
		emit_signal("props_changed", props)
