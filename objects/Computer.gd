extends Area2D

# this is me tryign to make a self-activated object
# it needs some work

var touching = false

func _on_Computer_body_entered(body):
	if body.name == "Player":
		touching = true

func _on_Computer_body_exited(body):
	if body.name == "Player":
		touching = false

func _input(event):
	if event.is_action_pressed("ui_accept") and touching and Global.player_can_move:
		print("dialog goes here, but it's broke.")
		var dialog = Global.show_dialog("PX9000", "Hello and welcome to the computer.", "left")
