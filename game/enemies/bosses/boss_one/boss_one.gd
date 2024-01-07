class_name BossOne extends Area2D

signal killed(point)
signal messeage()

@onready var shoot_points = $ShootPoints
@onready var idle_anim = $IdleAnim
@onready var animation = $AnimationPlayer
@onready var hurt_sound = $HurtSound


var life = 1
var stop_point = 1465
var point = 3000
var speed = 50
var direction = Vector2.LEFT
var explosion_instance = preload("res://game/animation/explosion/explosion.tscn")
var bullet_instance = preload("res://game/projectiles/enemy_bullet/enemy_bullet.tscn")

func _ready():
	animation.play("coming")
	animation.queue("attack")

func _process(delta):
	idle_anim.play("idle")
	print(life)


func explode():
	var explosion = explosion_instance.instantiate()
	explosion.global_position = global_position
	add_sibling(explosion)


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func take_damage(damage):
	life -= damage
	hurt_sound.play()
	hide()
	await get_tree().create_timer(0.05).timeout
	show()
	if life <= 0:
		queue_free()
		explode()
		killed.emit(point)
		messeage.emit()


func _on_area_entered(area):
	if area.is_in_group("player"):
		take_damage(3) 



func _on_shoot_cooldown_timeout():
	var bullet = bullet_instance.instantiate()
	bullet.global_position = shoot_points.get_children().pick_random().global_position
	add_sibling(bullet)
