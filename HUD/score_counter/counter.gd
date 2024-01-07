class_name ScoreCounter extends Control

@onready var score = $Score:
	set(value):
		score.text = str(value)

