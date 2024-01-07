class_name Explosion extends AnimatedSprite2D

@onready var sound_effect = $SoundEffect


func _ready():
	play("explode")
	sound_effect.play()

func _on_animation_finished():
	queue_free()
