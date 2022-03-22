extends KinematicBody2D

const GRAVITY = 9.2

onready var N_AnimationTree = get_node("KinematicBody2D/AnimationTree")

var y_velo = 0
var facing_right = false
var speed = 300
var velocity = Vector2()

var isOnGround  = true
var isMoving = false
var canAttack = true
var isStunned = false

func _physics_process(delta):
	print(getInputDirection())
	if getInputDirection().x != 0:
		isMoving = true
		velocity = move_and_slide(getInputDirection() * speed)
		move_and_slide(velocity)
	
func getInputDirection():
	var inputDirection = Vector2()
	inputDirection.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	inputDirection.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	if inputDirection.x == -1:
		facing_right = true
	else:
		facing_right = false
	return inputDirection
