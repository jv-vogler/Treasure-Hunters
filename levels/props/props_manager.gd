class_name PropsManager
extends Node

@onready var _parent: Level = self.get_parent()
@onready var _parent_path: String = self.get_parent().scene_file_path


func _ready() -> void:
	if _parent.props == {}:
		printerr("Parent %s does have any Props." % _parent)
		return
	_load_props()
	_parent.connect("props_changed", Callable(self, "_on_props_changed"))


func _load_props() -> void:
	var props = GameStateManager.get_props(_parent_path)
	if props:
		_parent.props = props
	else:
		GameStateManager.set_props(_parent_path, _parent.props)


func _on_props_changed(props: Dictionary) -> void:
	GameStateManager.set_props(_parent_path, props)
