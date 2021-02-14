extends Control

var current_scene = null
var scroll = 0

func _ready():
	$Container.visible = false
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)

# switch scenes
func goto_scene(path):
	call_deferred("_deferred_goto_scene", path)

func _deferred_goto_scene(path):
	current_scene.free()
	var s = ResourceLoader.load(path)
	current_scene = s.instance()
	get_tree().get_root().add_child(current_scene)
	get_tree().set_current_scene(current_scene)

# show a dialog box
func show_dialog(text, name):
	$Container/ScrollContainer.scroll_horizontal=0
	$Container.visible = true
	$Container/ScrollContainer/Text.bbcode_text = text
	$Container/MarginContainer/Name.text = name
	
