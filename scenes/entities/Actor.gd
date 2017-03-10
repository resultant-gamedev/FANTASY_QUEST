extends KinematicBody2D

export var direction = Vector2()
export var speed = 0

func _ready():
	set_fixed_process(true)

func move_and_slide(where):
	var motion = move(where)
	
	if is_colliding():
		var n = get_collision_normal()
		motion = n.slide(motion)
		direction = n.slide(direction)

func move_and_bounce(where):
	var motion = move(where)
	
	if is_colliding():
		var n = get_collision_normal()
		motion = n.reflect(motion)
		direction = n.reflect(direction)