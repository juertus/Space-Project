class_name Main extends Control

var user_settings: UserSettings

@onready var panel = $Main/Panel
@onready var settings = $Settings
@onready var music = $Settings/music
@onready var music_slider = %Music
@onready var sfx_slider = %SoundFX
@onready var credits = $Credits


func _ready():
	user_settings = UserSettings.load_or_create()
	if music_slider:
		music_slider.value = user_settings.music_volume_level
	if sfx_slider:
		sfx_slider.value = user_settings.sfx_volume_level
	
	music.play()


func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://game/gameplay/gameplay.tscn")


func show_and_hide(first, second):
	first.show()
	second.hide()


func _on_credits_button_pressed():
	show_and_hide(credits, panel)


func _on_back_from_credits_pressed():
	show_and_hide(panel, credits)


func _on_settings_button_pressed():
	show_and_hide(settings, panel)


func _on_back_from_settings_pressed():
	show_and_hide(panel, settings)


func _on_music_value_changed(value):
	AudioServer.set_bus_volume_db(1,linear_to_db(value))
	if user_settings:
		user_settings.music_volume_level = value
		user_settings.save()


func _on_sfx_value_changed(value):
	AudioServer.set_bus_volume_db(2,linear_to_db(value))
	if user_settings:
		user_settings.sfx_volume_level = value
		user_settings.save()


func _on_exit_button_pressed():
	get_tree().quit()
	
