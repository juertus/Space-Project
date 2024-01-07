class_name EnemyThree extends Area2D


signal killed(point)

var life = 15
var shoot_cd := false
var shoot_cd_timer = 10
var point = 200
var speed = 60
var direction = Vector2.LEFT
var explosion_instance = preload("res://game/animation/explosion/explosion.tscn")
var bullet_instance = preload("res://game/projectiles/enemy_bullet/enemy_bullet.tscn")

@onready var muzzle = $Muzzle
@onready var hurt_sound = $HurtSound


func _process(delta):
	translate(speed * direction * delta)
	
	if !shoot_cd:
		shoot_cd = true
		shoot()
		await get_tree().create_timer(shoot_cd_timer).timeout
		shoot_cd = false


func shoot():
	var bullet = bullet_instance.instantiate()
	bullet.global_position = muzzle.global_position
	add_sibling(bullet)


func explode():
	var explosion = explosion_instance.instantiate()
	explosion.global_position = global_position
	add_sibling(explosion)


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func take_damage(damage):
	life -= damage
	hurt_sound.play()
	if life <= 0:
		queue_free()
		explode()
		killed.emit(point)


func _on_area_entered(area):
	if area.is_in_group("player"):
		take_damage(life)

