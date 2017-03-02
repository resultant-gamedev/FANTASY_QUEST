# A PostProcessScript is instantiated by Preloader for processing
# loaded scenes.
extends Object

var scene = null

func _init(scene):
	self.scene = scene

# This is run once per frame until done() returns true.
# It will always run at least once.
func process():
	pass

# After process(), Preloader will check if this script is done(). EZPZ.
func done():
	return true