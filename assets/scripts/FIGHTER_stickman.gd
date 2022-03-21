extends KinematicBody2D

const GRAVITY = 200.0
const WALK_SPEED = 200

var velocity = Vector2()

var isOnGround  = true
var isMoving = false
var canAttack = true
var isStunned = false

func _physics_process(delta):
	velocity.y += GRAVITY * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	pass
	
	
func getInputDirection():
	var inputDirection = Vector2()
	inputDirection.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_right")
	inputDirection.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	return inputDirection
