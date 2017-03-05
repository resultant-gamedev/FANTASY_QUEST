extends KinematicBody2D

var moving = false
var direction = Vector2()
var speed = 0

func _ready():
	set_fixed_process(true)
