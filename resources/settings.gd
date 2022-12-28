class_name Settings
extends Resource

# Video
var fullscreen_enabled: bool
var window_size: Vector2i

# Audio
var music_volume: int
var music_muted: bool
var sfx_volume: int
var sfx_muted: bool

# Misc
var autosave_enabled: bool


func reset_to_default() -> void:
	pass
