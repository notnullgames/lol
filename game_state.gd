extends Node

# all global game-state variables & methods go in here
# (things that can be messed with in dialogs and other game-mechanics)
# if it is specific to a map, put it in the map's script, instead.

# this is the data that is saved and makes up a game
var current = {
	# quests that have been completed
	"quests_completed": [],
	
	# quests currently in profgress or taken-on
	"quests_incommplete": [],
	
	# current scene the player is in
	"current_scene": "",
	
	# position of player, in current_scene
	"position": [0, 0],
	
	# size of inventory for consumable/dropable items
	"bag_size": 5,
	
	# stuff limited by bag_size
	"inventory": {},
	
	# things that can be get/set in dialogs
	"switches": {}
}

# save game
func save(dialog="d0ef38b0-8dec-4b25-aa0e-e94e36976341"):
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	current.current_scene = current_scene.name
	var p = player.get_position()
	current.position = [p.x, p.y]
	var j = to_json(current)
	print("save savegame: ", j)
	save_game.store_line(j)
	save_game.close()
	show_dialog(dialog)

# load game
func load():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		return false
	save_game.open("user://savegame.save", File.READ)
	var j = save_game.get_line()
	print("load savegame: ", j)
	var o =  parse_json(j)
	o.position = Vector2(o.position[0], o.position[1])
	return o
	

# track what object is the  player
var player:KinematicBody2D
var camera:Camera2D

# this holds the last place before a scene-switch
var lastplace = Vector2.ZERO

onready var music = preload("res://sounds/ModPlayer.tscn").instance()

# can the player move?
var player_move = true

func set_player_move(p):
	player_move = p
	var wr = weakref(player)
	if not p and wr.get_ref():
		player.set_movement_vector(Vector2.ZERO)


# switch scenes
var current_scene = null
func goto_scene(path, position=Vector2.ZERO):
	var p = weakref(player)
	print("load map: %s" % path)
	if !p.get_ref():
		lastplace = Vector2.ZERO
	else:
		lastplace = player.get_position()
	call_deferred("_deferred_goto_scene", path, position)
func _deferred_goto_scene(path, position=Vector2.ZERO):
	current_scene.free()
	var s = ResourceLoader.load(path)
	current_scene = s.instance()
	get_tree().get_root().add_child(current_scene)
	get_tree().set_current_scene(current_scene)
	if position != Vector2.ZERO:
		player.set_position(position)

# show a SayWhat dialog
func show_dialog(id: String) -> void:
	DialogueManager.game_state = current_scene
	set_player_move(false)
	var dialog = yield(DialogueManager.get_next_dialogue_line(id), "completed")
	if dialog != null:
		var balloon = ResourceLoader.load("res://Dialog.tscn").instance()
		balloon.handle(dialog)
		add_child(balloon)
		show_dialog(yield(balloon, "dialog_actioned"))
	else:
		set_player_move(true)

# show a panel to the user
func show_panel(code, map_success):
	var map_back = current_scene.name
	var position_back = Vector2.ZERO
	var p = weakref(player)
	if not p.get_ref():
		position_back = player.get_position()
	goto_scene("res://maps/PanelEntry.tscn")
	call_deferred("_deferred_show_panel", code, map_success, map_back, position_back)
func _deferred_show_panel(code, map_success, map_back, position_back):
	current_scene.code = code
	current_scene.map_success = map_success
	current_scene.map_back = map_back
	position_back = position_back
	

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	DialogueManager.resource = preload("res://dialog.tres")
	add_child(music)
	

func _input(event):
	if event.is_action_pressed('ui_quicksave'):
		 save()
		
	var wr = weakref(player)
	if player_move and wr.get_ref():
		var movement_vector = player.get_movement_vector()
		movement_vector = Vector2.ZERO
		movement_vector.x = Input.get_action_strength('ui_right') - Input.get_action_strength('ui_left')
		movement_vector.y = Input.get_action_strength('ui_down') - Input.get_action_strength('ui_up')
		player.set_movement_vector(movement_vector.normalized())
		if event.is_action_pressed('ui_accept') and player.touching and funcref(player.touching, 'on_activate').is_valid():
			player.touching.on_activate()
		# B toggles zoom
		if event.is_action_pressed('ui_cancel'):
			if camera.zoom == Vector2(2, 2):
				camera.zoom = Vector2(1, 1)
			else:
				camera.zoom = Vector2(2, 2)
