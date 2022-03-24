extends KinematicBody2D

const GRAVITY = 9.2

var y_velo = 0
var facing_right = false
var speed = 300
var jumpForce = 50
var velocity = Vector2()

var isOnGround  = true
var isMoving = false
var canAttack = true
var isStunned = false
var isJumping = false

func _physics_process(delta):
	handleInputs()
	
	doGraviy()
		
	if $groundCheck.is_colliding():
		y_velo = 0
		isOnGround = true
	else:
		isOnGround = false
	print(getInputDirection())
	if getInputDirection().x != 0:
		isMoving = true
	#	velocity = move_and_slide(Vector2(getInputDirection().x * speed, y_velo))
	#	move_and_slide(velocity, Vector2(0, 1))
	else:
		isMoving = false
	velocity = move_and_slide(Vector2(getInputDirection().x * speed, y_velo))
	move_and_slide(velocity, Vector2(0, 1))
	print(y_velo)
		
	doAnimation()
	
func getInputDirection():
	var inputDirection = Vector2()
	inputDirection.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	inputDirection.y = Input.get_action_strength("ui_up") - Input.get_action_strength("ui_down")
	if inputDirection.x == -1:
		facing_right = true
	else:
		facing_right = false
	return inputDirection

func doAnimation():
	if isOnGround:
		$AnimationTree.set("parameters/isOnGround/current", 1)
		if isMoving:
			$AnimationTree.set("parameters/isWalking/current", 1)
		else:
			$AnimationTree.set("parameters/isWalking/current", 0)
	else:
		$AnimationTree.set("parameters/isOnGround/current", 0)

func handleInputs():
	if Input.is_action_just_pressed("ui_accept"):
		#if isOnGround:
		y_velo = jumpForce
		print("hyppää")
		
	if Input.is_action_just_pressed("close_game"):
		get_tree().quit()
	if Input.is_action_just_pressed("reload_scene"):
		get_tree().reload_current_scene()

func doGraviy():
	pass
