extends Node2D

var PostProcessScript = preload("res://scripts/PostProcessScript.gd")

# Skip frames between load steps? Mostly cosmetic.
# Show off effects or something.
const FRAME_DELAY = 1

# How much frame should we consume loading? (in milliseconds)
const MAX_BLOCK_TIME = 8

export(String, FILE, "*.tscn,*.scn") var target_scene = "res://scenes/main.tscn"
export(String, FILE, "*.gd") var postprocess_script = null

signal load_error(message)
signal load_progress(loaded, total)
signal load_finished()

var loader
var process_script = null
var frame_delay = FRAME_DELAY
var loaded_resource = null

func _ready():
	loader = ResourceLoader.load_interactive(target_scene)
	
	if loader == null:
		emit_signal("load_error", "Resource not found.")
		return
	
	set_process(true)

func _process(delta):
	# Frame skipping.
	if frame_delay > 0:
		frame_delay -= 1
		return
	else:
		frame_delay = FRAME_DELAY
	
	# Only runs after loading's done.
	# Will either switch scenes immediately, or handle a PostProcessScript first.
	if loader == null:
		if postprocess_script != null:
			if process_script == null:
				process_script = load(postprocess_script).new(loaded_resource)
			
			process_script.process()
				
			if process_script.done():
				SceneManager.set_scene(loaded_resource)
				set_process(false)
		else:
			SceneManager.set_scene(loaded_resource)
			set_process(false)
			return
		
		return
	
	# Actual loading, basically ripped verbatim from the Godot docs.
	var time = OS.get_ticks_msec()
	while OS.get_ticks_msec() < time + MAX_BLOCK_TIME:
		var result = loader.poll()
		
		if result == ERR_FILE_EOF:
			loaded_resource = loader.get_resource().instance()
			emit_signal("load_finished")
			loader = null
			break
		elif result == OK:
			emit_signal("load_progress", loader.get_stage(), loader.get_stage_count())
		else:
			emit_signal("load_error", "Loading error occurred. Bad file format?")
			loader = null
			break