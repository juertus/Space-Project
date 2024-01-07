class_name GameOverScreen extends Control


@onready var gameplay = $"../.."
@onready var high_score = $Panel/HighScore
@onready var score = $Panel/Score


func set_high_score(value):
	high_score.text = "High Score:" + str(value)

func set_score(value):
	score.text = "Score:" + str(value)


func _on_try_again_pressed():
	get_tree().reload_current_scene()
	gameplay.new_game()

func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://GUI/main_menu/main_menu.tscn")
