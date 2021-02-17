extends Area2D

# this is me trying to make a self-activated object
# it needs some work

var touching = false

export(String, MULTILINE) var text

func _input(event):
	if touching and event.is_action_pressed("ui_accept") and Global.player_can_move:
		var dialog = Global.show_dialog("PX9000", text, "left")

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		touching = true
		$AnimatedSprite.play("on")


func _on_Area2D_body_exited(body):
	if body.name == "Player":
		touching = false
		$AnimatedSprite.play("off")
