class_name Boost extends Area2D


var speed = 500
var direction = Vector2.LEFT
var min_missile := 1
var max_missile := 3
var min_life := 1
var max_life := 2

@onready var icon = $Icon
@onready var idle = $sounds/idle
@onready var collide = $sounds/collide
@onready var collision_shape= $CollisionShape2D


func _physics_process(delta):
	translate(direction * speed * delta)
	
	icon.global_rotation_degrees += -2
	
	
	if Engine.time_scale == 0:
		idle.stop()


func missile_boost():
	Variables.player_missile += randi_range(min_missile, max_missile)
	if Variables.player_missile >= Variables.max_player_missile:
		Variables.player_missile = Variables.max_player_missile


func life_boost():
	Variables.player_life += randi_range(min_life, max_life)
	if Variables.player_life >= Variables.max_player_life:
		Variables.player_life = Variables.max_player_life


func make_boost():
	var random_number = randi_range(1,2)
	if random_number == 1:
		missile_boost()
	elif random_number == 2:
		life_boost()


func _on_area_entered(area):
	if area.is_in_group("player"):
		idle.stop()
		collide.play()
		make_boost()
		icon.hide()
		collision_shape.set_deferred("disabled", true)


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
