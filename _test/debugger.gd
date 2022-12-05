extends CanvasLayer

var stats = []


func add_stat(stat_name, object, stat_ref, is_method = false) -> void:
	stats.append([stat_name, object, stat_ref, is_method])


func _process(_delta: float) -> void:
	var label_text = ""

	for s in stats:
		var value = null
		if s[1] and weakref(s[1]).get_ref():
			if s[3]:
				value = s[1].call(s[2])
			else:
				value = s[1].get(s[2])
		label_text += str(
			"[table=2][cell][u]%s[/u]: [/cell][cell][color=lime][b]%s[/b][/color][/cell][/table]" %
			[s[0], value]
			)
		label_text += "\n"
	$Panel/Label.text = label_text
