class_name PauseMenu extends CanvasLayer


@onready var gameplay = $"../.."
@onready var high_score = $HighScore



func show_high_score(value):
	high_score.text = "High Score: " + str(value)


func _on_main_menu_buton_pressed():
	get_tree().call_group("must_delete","queue_free")
	get_tree().change_scene_to_file("res://GUI/main_menu/main_menu.tscn")
	Engine.time_scale = 1


func _on_restart_button_pressed():
	get_tree().call_group("must_delete","queue_free")
	get_tree().change_scene_to_file("res://game/gameplay/gameplay.tscn")
	gameplay.new_game()
	Engine.time_scale = 1


func _on_quit_button_pressed():
	get_tree().quit()
