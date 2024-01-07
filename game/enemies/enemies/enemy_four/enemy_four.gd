class_name EnemyFour extends Area2D

signal killed(point)


var life = 1
var point = 60
var speed = 600
var target_position = Vector2(-250, 150)
var explosion_instance = preload("res://game/animation/explosion/explosion.tscn")
var bullet_instance = preload("res://game/projectiles/enemy_bullet/enemy_bullet.tscn")


func _process(delta):
	var current_position: Vector2 = position
	var direction : Vector2 = (target_position - current_position).normalized()
	var movement: Vector2 = direction * speed * delta
	position += movement
	#translate(speed * direction * delta) 


func explode():
	var explosion = explosion_instance.instantiate()
	explosion.global_position = global_position
	add_sibling(explosion)


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func take_damage(damage):
	life -= damage
	if life <= 0:
		queue_free()
		explode()
		killed.emit(point)


func _on_area_entered(area):
	if area.is_in_group("player"):
		take_damage(life)
