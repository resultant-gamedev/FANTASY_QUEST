extends Node

var Preloader = preload("res://scenes/Preloader.tscn")
var current_scene = null

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)

func get_scene():
	return current_scene

func set_scene(path_or_scene):
	# if it's a path, just block until it's loaded
	if typeof(path_or_scene) == TYPE_STRING:
		path_or_scene = ResourceLoader.load(path_or_scene)
	
	# otherwise throw it at the scene swapper
	# it can handle both packedscenes and scenes
	call_deferred("_deferred_set_scene", path_or_scene)

func set_scene_preloaded(path, script = null):
	# create an instance of the preloader, setting the path
	var preloader_instance = Preloader.instance()
	preloader_instance.target_scene = path
	preloader_instance.postprocess_script = script
	
	# swap to the preloader scene
	call_deferred("_deferred_set_scene", preloader_instance)

func _deferred_set_scene(scene):
	current_scene.free()
	
	if scene extends PackedScene:
		current_scene = scene.instance()
	else:
		current_scene = scene
	
	get_tree().get_root().add_child(current_scene)
	get_tree().set_current_scene(current_scene)