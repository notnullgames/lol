extends CanvasLayer

var current_scene = null

# global used to check if player can move
var player_can_move = true

# show a dialog box
func show_dialog(name, text, name_align="left"):
	return $DialogControl.show_dialog(name, text, name_align)

# switch scenes
func goto_scene(path):
	call_deferred("_deferred_goto_scene", path)

func _deferred_goto_scene(path):
	current_scene.free()
	var s = ResourceLoader.load(path)
	current_scene = s.instance()
	get_tree().get_root().add_child(current_scene)
	get_tree().set_current_scene(current_scene)

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
