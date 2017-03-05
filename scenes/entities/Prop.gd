extends KinematicBody2D

# TODO: Implement "bumped" handlers; "push," "grid_push," "switch" perhaps with delay
var direction = Vector2()
var speed = 0
var friction = 0.2

func _ready():
	set_fixed_process(false)

func _fixed_process(delta):
	if speed > 0:
		var motion = move(direction * speed * delta)
		
		if is_colliding():
			if get_collider().has_method("bumped"):
				get_collider().bumped(self, motion)
			motion = move(get_collision_normal().slide(motion))
			direction = motion.normalized()
			speed *= .5
	
	speed = speed * friction
	if speed < 0.05:
		speed = 0
		set_fixed_process(false)

func bumped(other, other_motion):
	direction = (get_global_pos() - other.get_global_pos()).normalized()
	speed = 64
	set_fixed_process(true)