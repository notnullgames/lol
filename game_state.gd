extends Node

# all global game-state variables & methods go in here
# (things that can be messed with in dialogs and other game-mechanics)
# if it is specific to a map, put it in the map's script, instead.

# track what object is the  player
var player:KinematicBody2D

var player_move = true

# switch scenes
var current_scene = null
func goto_scene(path):
	call_deferred("_deferred_goto_scene", path)
func _deferred_goto_scene(path):
	current_scene.free()
	var s = ResourceLoader.load(path)
	current_scene = s.instance()
	get_tree().get_root().add_child(current_scene)
	get_tree().set_current_scene(current_scene)

# show a SayWhat dialog
func show_dialog(id: String) -> void:
	player_move = false
	var dialog = yield(DialogueManager.get_next_dialogue_line(id), "completed")
	if dialog != null:
		var balloon = ResourceLoader.load("res://Dialog.tscn").instance()
		balloon.handle(dialog)
		add_child(balloon)
		show_dialog(yield(balloon, "dialog_actioned"))
	else:
		player_move = true

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	DialogueManager.resource = preload("res://dialog.tres")
	DialogueManager.game_state = self
	

func _input(event):
	if player and player_move:
		var movement_vector = player.get_movement_vector()
		movement_vector = Vector2.ZERO
		movement_vector.x = Input.get_action_strength('ui_right') - Input.get_action_strength('ui_left')
		movement_vector.y = Input.get_action_strength('ui_down') - Input.get_action_strength('ui_up')
		player.set_movement_vector(movement_vector.normalized())
		if event.is_action_pressed('ui_accept') and player.touching and funcref(player.touching, 'on_activate').is_valid():
			player.touching.on_activate()
