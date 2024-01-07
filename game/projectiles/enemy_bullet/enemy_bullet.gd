class_name EnemyProjectile

extends Area2D

var speed = 750
var direction = Vector2.LEFT

@onready var sound = $Sound


func _ready():
	sound.play()

func _process(delta):
	translate(direction * speed * delta)


func _on_area_entered(area):
	if area.is_in_group("player"):
		area.take_damage(1)
		queue_free()
	if area is PlayerProjectile:
		queue_free()
