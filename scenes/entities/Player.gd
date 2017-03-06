extends "Character.gd"

# TODO: Interactions - signs, chests, etc.
# TODO: 'Delay'/vulnerability while bullet is active?

var Character = preload("Character.gd")

const WALK_SPEED = 128

func _ready():
	facing = Character.DIR_RIGHT
	set_process_input(true)

func _input(evt):
	if evt.type == InputEvent.KEY:
		if evt.is_action("use") and evt.pressed and not evt.is_echo():
			use()
		if evt.is_action("interact") and evt.pressed and not evt.is_echo():
			interact()

func _fixed_process(delta):
	update_input()
	
	if moving:
		var motion = move(direction * speed * delta)
		if is_colliding():
			var body = get_collider()
			
			if body.has_method("bumped"):
				body.bumped(self, motion)
			
			motion = move(get_collision_normal().slide(motion))
	
	update_sprite()

func use():
	var bullet = preload("BulletSwordSlash.tscn").instance()
	bullet.shoot_from(self, get_spawn_node())

func interact():
	var facing_vector = (get_node(get_facing()).get_global_pos() - get_global_pos()).normalized()
	facing_vector *= 32
	var ray = get_node("Facing")
	ray.set_cast_to(facing_vector)
	ray.force_raycast_update()
	if ray.is_colliding():
		var other = ray.get_collider()
		
		if other.has_method("interacted"):
			other.interacted(self, facing_vector)

func update_input():
	moving = false
	
	var u = Input.is_action_pressed("move_up")
	var d = Input.is_action_pressed("move_down")
	var l = Input.is_action_pressed("move_left")
	var r = Input.is_action_pressed("move_right")
	
	var dir = Vector2()
	
	if u or d or l or r:
		moving = true
	
	if u:
		if not (l or r):
			self.facing = Character.DIR_UP
		dir += Vector2(0, -1)
	elif d:
		if not (l or r):
			self.facing = Character.DIR_DOWN
		dir += Vector2(0, 1)
	
	if l:
		self.facing = Character.DIR_LEFT
		dir += Vector2(-1, 0)
	elif r:
		self.facing = Character.DIR_RIGHT
		dir += Vector2(1, 0)
	
	
	direction = dir.normalized() if moving else direction
	speed = WALK_SPEED if moving else 0

# TODO: Implement using Godot animations?
func update_sprite():
	if moving:
		if facing == Character.DIR_RIGHT:
			get_node("Sprite").set_frame(0)
		elif facing == Character.DIR_LEFT:
			get_node("Sprite").set_frame(2)
		elif facing == Character.DIR_UP:
			get_node("Sprite").set_frame(1)
		elif facing == Character.DIR_DOWN:
			get_node("Sprite").set_frame(3)