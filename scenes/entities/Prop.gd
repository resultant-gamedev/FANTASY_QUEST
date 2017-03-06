extends KinematicBody2D

# TODO: Implement "bumped" handlers; "push," "grid_push," "switch" perhaps with delay
# FIXME: Broken physics.

var direction = Vector2()
var speed = 0
var friction = 0.9

func _ready():
	set_fixed_process(false)

func _fixed_process(delta):
	get_node("Sprite").set_modulate(Color(1,0,0))
	
	if speed > 0:
		var motion = move(direction * speed * delta)
		
		if is_colliding():
			if get_collider().has_method("bumped"):
				get_collider().bumped(self, motion)
			motion = move(get_collision_normal().reflect(motion))
			direction = motion.normalized()
	
	speed = speed * friction
	if speed < 0.05:
		speed = 0
		get_node("Sprite").set_modulate(Color(1,1,1))
		set_fixed_process(false)

func bumped(other, other_motion):
	if other extends get_script():
		direction = (get_global_pos() - other.get_global_pos()).normalized()
		speed = 128
		set_fixed_process(true)

func interacted(other, direction):
	self.direction = direction
	speed = 128
	set_fixed_process(true)