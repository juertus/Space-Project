extends Control

signal shoot_pressed

@onready var shoot_button = $ShootButton


func _process(_delta):
	if shoot_button.is_pressed():
		emit_signal("shoot_pressed")

