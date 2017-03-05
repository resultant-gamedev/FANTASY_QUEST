# Base class for all characters. Player, enemies, etc.
extends "Actor.gd"

const DIR_RIGHT = "Right"
const DIR_UP = "Up"
const DIR_LEFT = "Left"
const DIR_DOWN = "Down"

var facing = DIR_DOWN setget set_facing, get_facing

signal facing_changed(from, to)

func _fixed_process(delta):
	pass

func set_facing(to):
	if to != facing:
		emit_signal("facing_changed", facing, to)
	facing = to

func get_facing():
	return facing

func get_spawn_node():
	return get_node(facing)