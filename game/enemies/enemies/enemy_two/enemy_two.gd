class_name EnemyTwo extends Area2D


signal killed(point)

var life = 2
var point = 50
var speed = 750
var target = null
var direction = Vector2.LEFT
var explosion_instance = preload("res://game/animation/explosion/explosion.tscn")

@onready var animated_sprite = $AnimatedSprite2D
@onready var hurt_sound = $HurtSound


func _physics_process(delta):
	translate(direction * speed * delta)
	
	if is_instance_valid(target):
		direction = target.global_position - global_position
		direction = direction.normalized()
		look_at(target.global_position)
		animated_sprite.rotation_degrees = 180
		speed += 80


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



func _on_dedect_area_area_entered(area):
	if area.is_in_group("player"):
		target = area
