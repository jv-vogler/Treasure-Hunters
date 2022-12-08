class_name Utils
extends Node


static func get_percent(current_value, max_value) -> int:
	return int((float(current_value) / max_value) * 100)
