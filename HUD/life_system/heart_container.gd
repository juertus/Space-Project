extends HBoxContainer

@onready var heart_instance = preload("res://HUD/life_system/heart/heart.tscn")


func set_max_hearts(max: int):
	for i in range(max):
		var heart = heart_instance.instantiate()
		add_child(heart)

func heart_changed(current_heart: int):
	var hearts = get_children()

	for i in range(current_heart):
		hearts[i].update(true)

	for i in range(current_heart, hearts.size()):
		hearts[i].update(false)
