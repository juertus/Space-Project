class_name HomingMissile extends Area2D

var direction = Vector2.RIGHT
var speed = 600
var target = null

@onready var sound = $sound


func _ready():
	sound.play()


func _physics_process(delta):
	translate(direction * speed * delta)
	
	if is_instance_valid(target):
		direction = target.global_position - global_position
		direction = direction.normalized()
		look_at(target.position)
		speed += 50


func _on_area_entered(area):
	if area.is_in_group("enemies"):
		area.take_damage(10)
		queue_free()


func _on_dedect_area_area_entered(area):
	if area.is_in_group("enemies"):
		target = area


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
