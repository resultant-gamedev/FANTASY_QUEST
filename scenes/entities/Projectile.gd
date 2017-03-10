extends KinematicBody2D

# TODO: Implement sword and shield.

const SPECIFIC_VALUE = 0
const SHOOTER_MOTION = 1
const SHOOTER_FACING = 2
const RANDOM = 3

export var attached = true
export var oriented = false
export var use_spawn_node = true
export(int, "Specific Value (below)", "Shooter Motion", "Shooter Facing", "Random") var motion_type = SPECIFIC_VALUE
export var direction = Vector2(0, 0)
export var speed = 512
export var time_to_live = 1.0

var shooter = null

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	if speed > 0:
		var motion = move(direction.normalized() * speed * delta)
		
		if is_colliding():
			motion = move(get_collision_normal().slide(motion))
	
	time_to_live -= delta
	if time_to_live <= 0:
		self_destruct()

func shoot_from(shooter, spawn_node = null):
	self.shooter = shooter
	
	if attached:
		if spawn_node and use_spawn_node:
			spawn_node.add_child(self)
		else:
			shooter.add_child(self)
	else:
		if spawn_node and use_spawn_node:
			set_global_pos(spawn_node.get_global_pos())
		else:
			set_global_pos(shooter.get_global_pos())
		
		shooter.get_tree().get_root().add_child(self)
	
	if oriented:
		shooter.connect("facing_changed", self, "reorient")
	
	if motion_type == SHOOTER_MOTION:
		direction = shooter.direction
	elif motion_type == SHOOTER_FACING:
		direction = shooter.get_facing_direction()
	elif motion_type == RANDOM:
		direction = 2 * Vector2(randf() - 0.5, randf() - 0.5);

func reorient(from, to):
	if attached:
		shooter.get_node(from).remove_child(self)
		shooter.get_node(to).add_child(self)

func self_destruct():
	if oriented:
		shooter.disconnect("facing_changed", self, "reorient")
	get_parent().remove_child(self)