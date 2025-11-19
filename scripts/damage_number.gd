extends Node2D

@export var float_speed: float = 40.0
@export var lifetime: float = 0.6
@onready var label: Label = $Label

var time_passed = 0.0

func setup(damage: int):
	label.text = str(damage)

func _process(delta):
	# faz subir
	position.y -= float_speed * delta

	# timer
	time_passed += delta
	if time_passed >= lifetime:
		queue_free()
