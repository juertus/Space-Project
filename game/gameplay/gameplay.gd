class_name Gameplay extends Node2D


@export var enemies : Array [PackedScene] = []
@export var special_enemies : Array [PackedScene] = []
@export var heavy_enemies : Array [PackedScene] = []

var paused = false
var high_score = 0
var booster_instance = preload("res://game/boost/boost.tscn")
var boss_one = preload("res://game/enemies/bosses/boss_one/boss_one.tscn")

@onready var player = $Player
@onready var score_counter = $UI/ScoreCounter
@onready var heart_container = $UI/HeartContainer
@onready var game_over_screen = $UI/GameOverScreen
@onready var enemy_spawn_timer = $Timers/EnemySpawnTimer
@onready var special_enem_spawn_timer = $Timers/SpecialEnemSpawnTimer
@onready var heavy_enemy_spawn_timer = $Timers/HeavyEnemySpawnTimer
@onready var boost_spawn_timer = $Timers/BoostSpawnTimer
@onready var special_enemy_spawner = $SpecialEnemySpawner
@onready var border = $UI/Bg/border
@onready var pause_screen = $UI/PauseScreen
@onready var buttons = $Buttons
@onready var pause_button = $Buttons/PauseButton
@onready var shooting_buttons = $Buttons/ShootingButtons
@onready var music = %Music
@onready var sfx = %Sfx
@onready var thank_you = $UI/ThankYou
@onready var main_theme = $MainTheme
@onready var homing_missile_counter = $UI/HomingMissileCounter/Panel/Label


func new_game():
	Variables.player_life = 3
	Variables.player_missile = 3
	score_counter.score = 0

var score := 0:
	set(value):
		score = value
		score_counter.score = value

func _ready():
	new_game()
	load_high_score()
	update_life()
	
	#pause_screen.show_high_score(high_score)
	
	user_settings = UserSettings.load_or_create()
	if music:
		music.value = user_settings.music_volume_level
	if sfx:
		sfx.value = user_settings.sfx_volume_level
	
	
		border.scale.y = 0.2
	for i in get_viewport_rect().size.x:
		border.scale.x = i
	
	
	main_theme.play()


func _process(_delta):
	homing_missile_counter.text = ":" + str(Variables.player_missile)
	heart_container.heart_changed(Variables.player_life)


func update_life():
	heart_container.set_max_hearts(Variables.max_player_life)
	heart_container.heart_changed(Variables.player_life)
	player.taking_damage.connect(heart_container.heart_changed)
	player.killed.connect(_on_player_killed)


func save_high_score():
	var save_file = FileAccess.open("user://save_game.data", FileAccess.WRITE)
	save_file.store_32(high_score)


func load_high_score():
	var save_file = FileAccess.open("user://save_game.data", FileAccess.READ)
	if save_file != null:
		high_score = save_file.get_32()
	else:
		high_score = 0
		save_high_score()


func _on_enemy_killed(point):
	score += point
	if score >= high_score:
		high_score = score


func _on_player_killed():
	main_theme.stop()
	get_tree().call_group("must_delete","queue_free")
	enemy_spawn_timer.stop()
	special_enem_spawn_timer.stop()
	heavy_enemy_spawn_timer.stop()
	boost_spawn_timer.stop()
	game_over_screen.set_score(score)
	game_over_screen.set_high_score(high_score)
	save_high_score()
	await get_tree().create_timer(2).timeout
	game_over_screen.show()
	buttons.hide()


func _on_enemy_spawn_timer_timeout():
	var enemy = enemies.pick_random().instantiate()
	enemy.global_position = Vector2(1680, randf_range(200,650))
	add_sibling(enemy)
	enemy.killed.connect(_on_enemy_killed)


func _on_special_enem_spawn_timer_timeout():
	for j in randf_range(0,3):
		var special_enemy = special_enemies.pick_random().instantiate()
		special_enemy.global_position = special_enemy_spawner.get_children().pick_random().global_position
		add_sibling(special_enemy)
		await get_tree().create_timer(0.25).timeout


func _on_heavy_enemy_spawn_timer_timeout():
	var heavy_enemy = heavy_enemies.pick_random().instantiate()
	heavy_enemy.global_position = Vector2(1680, randf_range(200,650))
	add_sibling(heavy_enemy)
	heavy_enemy.killed.connect(_on_enemy_killed)


func _on_boost_spawn_timer_timeout():
	var booster = booster_instance.instantiate()
	booster.global_position = Vector2(1680, randf_range(200,650))
	add_sibling(booster)


func _on_boss_spawn_timeout():
	var boss_instance = boss_one.instantiate()
	boss_instance.global_position = Vector2(1680, 325)
	add_sibling(boss_instance)
	boss_instance.killed.connect(_on_enemy_killed)
	boss_instance.messeage.connect(_show_messeage)
	enemy_spawn_timer.stop()
	special_enem_spawn_timer.stop()
	heavy_enemy_spawn_timer.stop()


func _on_close_messeage_pressed():
	thank_you.queue_free()
	enemy_spawn_timer.start()
	special_enem_spawn_timer.start()
	heavy_enemy_spawn_timer.start()


func _on_pause_button_pressed():
	pause_screen.show_high_score(high_score)
	if paused:
		pause_screen.hide()
		pause_button.texture_normal = load("res://assets/icons/pause_menu.png")
		Engine.time_scale = 1
		shooting_buttons.show()
	else:
		pause_screen.show()
		pause_button.texture_normal = load("res://assets/icons/cancel_button.png")
		Engine.time_scale = 0
		shooting_buttons.hide()
	paused = !paused


var user_settings: UserSettings

func settings():
	user_settings = UserSettings.load_or_create()
	if music:
		music.value = user_settings.music_volume_level
	if sfx:
		sfx.value = user_settings.sfx_volume_level

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


func _show_messeage():
	thank_you.show()
