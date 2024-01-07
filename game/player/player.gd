class_name Player extends Area2D

signal killed
signal taking_damage

const starter_position := Vector2(150, 400)

var Speed := 800
var shoot_cd := false
var can_shoot = false
var shoot_cd_timer := 0.15

@onready var shield = $Shield
@onready var muzzle = $Muzzle
@onready var collision = $Collision
@onready var invincibility_timer = $Shield/InvincibilityTimer
@onready var homing_missile_instance = preload("res://game/projectiles/homing_missile/homing_missile.tscn")
@onready var bullet_instance = preload("res://game/projectiles/player_bullet/player_bullet.tscn")
@onready var explosion_instance = preload("res://game/animation/explosion/explosion.tscn")
@onready var screensize = get_viewport_rect().size


func _ready():
	position = starter_position
	shield.visible = false


func _process(delta: float):
	## to make player move
	var move_vector = Vector2.ZERO
	move_vector.x = Input.get_axis("ui_left", "ui_right")
	move_vector.y = Input.get_axis("ui_up", "ui_down")
	position += move_vector * Speed * delta
	
	
	## to restrict the player
	position.x = clamp(position.x, 100, screensize.x - 100)
	position.y = clamp(position.y, 200, screensize.y - 70)


func shoot():
	var bullet = bullet_instance.instantiate()
	bullet.global_position = muzzle.global_position
	add_sibling(bullet)


func homing_missile():
	var homing_missile = homing_missile_instance.instantiate()
	homing_missile.global_position = muzzle.global_position
	add_sibling(homing_missile)


func explode():
	var explosion = explosion_instance.instantiate()
	explosion.global_position = global_position
	add_sibling(explosion)


func take_damage(damage):
	if not invincibility_timer.is_stopped():
		return
	invincibility_timer.start()
	shield.visible = true
	collision.scale *= 1.5
	
	explode()
	
	Variables.player_life -= damage
	taking_damage.emit(Variables.player_life)
	global_position = starter_position
	
	if Variables.player_life <= 0:
		queue_free()
		killed.emit()


func _on_invincibility_timer_timeout():
	$Shield.visible = false
	$Collision.scale /= 1.5


func _on_shoot_control_shoot_pressed():
	if !shoot_cd:
		shoot_cd = true
		shoot()
		await get_tree().create_timer(shoot_cd_timer).timeout
		shoot_cd = false


func _unhandled_input(event):
	if Variables.player_missile <= 0:
		can_shoot = false
	else:
		can_shoot = true

	if event.is_action_pressed("super_shoot") and can_shoot == true:
		homing_missile()
		Variables.player_missile -= 1


func _on_area_entered(area):
	if area.is_in_group("enemies"):
		take_damage(1)

