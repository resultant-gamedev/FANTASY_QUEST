# Simple example.
# Prints the name of every scene node sequentially after load.

# _init(scene) once
# process() -> done() -> repeat, if true

extends "PostProcessScript.gd"

var index = 0

func _init(scene).(scene):
	pass

func process():
	# don't break on empty scenes, ;p
	if scene.get_child_count() > 0:
		print(scene.get_child(index).get_name())
		index += 1

func done():
	return index == scene.get_child_count()