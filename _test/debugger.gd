class_name Debugger
extends Control


var debug: String = ""


func _process(_delta: float) -> void:
	self.text = debug
