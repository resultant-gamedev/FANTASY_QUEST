extends RigidBody2D

# TODO: Moar props!

var sleep_threshold_linear = Globals.get("physics_2d/sleep_threashold_linear")
var time_before_sleep = Globals.get("physics_2d/time_before_sleep")
var countdown = time_before_sleep

func _ready():
	pass

# Need to reimplement sleeping as MODE_CHARACTER does not sleep, ever
func _integrate_forces(state):
	if not is_sleeping() and state.get_linear_velocity().length() < sleep_threshold_linear:
		if countdown < 0:
			set_sleeping(true)
			on_sleep_state_change()
			countdown = time_before_sleep
		countdown -= state.get_step()

func bumped(other, other_motion):
	var opposite = (get_global_pos() - other.get_global_pos()).normalized()
	set_mode(RigidBody2D.MODE_CHARACTER)
	apply_impulse(Vector2(0, 0), opposite * 8)

func interacted(other, direction):
	var impulse = direction * 512
	set_mode(RigidBody2D.MODE_CHARACTER)
	apply_impulse(Vector2(0, 0), impulse)

func on_sleep_state_change():
	if is_sleeping():
		set_mode(RigidBody2D.MODE_STATIC)
		get_node("Sprite").set_modulate(Color(0.5, 0.5, 0.5))
	else:
		get_node("Sprite").set_modulate(Color(1, 1, 1))

func _on_body_enter( body ):
	set_opacity(0.25)
