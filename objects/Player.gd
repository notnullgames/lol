extends KinematicBody2D

# tune these to change the feel of the movement
const ACCELERATION = 500
const MAX_SPEED = 80
const FRICTION = 500

onready var animationState = $AnimationTree.get("parameters/playback")
var velocity =  Vector2.ZERO

func _physics_process(delta):
	if Global.player_can_move:
		var input_vector = Vector2.ZERO
		input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		input_vector = input_vector.normalized()
		if input_vector != Vector2.ZERO:
			$AnimationTree.set("parameters/Idle/blend_position", input_vector)
			$AnimationTree.set("parameters/Walk/blend_position", input_vector)
			animationState.travel("Walk")
			velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
		else:
			animationState.travel("Idle")
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		velocity = move_and_slide(velocity)
	
