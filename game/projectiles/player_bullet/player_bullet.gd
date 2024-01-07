class_name PlayerProjectile extends Area2D

var speed := 1000
var direction = Vector2.RIGHT

@onready var sound = $sound


func _ready():
	sound.play()

func _process(delta):
	translate(direction * speed * delta)


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_area_entered(area):
	if area.is_in_group("enemies"):
		area.take_damage(1)
		queue_free()
	if area is EnemyProjectile:
		queue_free()
