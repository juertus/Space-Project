class_name HeartIcon extends Panel

@onready var heart_icon = $HeartIcon


func update(whole: bool):
	if whole: heart_icon.visible = true
	else: heart_icon.visible = false
