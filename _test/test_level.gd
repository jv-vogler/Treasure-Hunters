extends Level


func _ready() -> void:
	GameStateManager.inventory.add_item("health_potion", 5)
	GameStateManager.inventory.add_item("poison_bottle", 5)
	GameStateManager.inventory.add_item("stat_potion", 5)
