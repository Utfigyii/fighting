extends KinematicBody2D

const GRAVITY = 9.2

var y_velo = 0
var facing_right = false
var speed = 300
var jumpForce = 50
var velocity = Vector2()

var isOnGround  = true
var isMoving = false
var isStunned = false
var isJumping = false
var isAttacking = false
var isCrouching = false
var canMove = true
var canJump = true
var canAttack = true

func _physics_process(delta):
	handleInputs()
	
	doGravity(delta)
	
	print(getInputDirection())
	if getInputDirection().x != 0 && canMove:
		isMoving = true
	#	velocity = move_and_slide(Vector2(getInputDirection().x * speed, y_velo))
	#	move_and_slide(velocity, Vector2(0, 1))
	else:
		isMoving = false
	velocity = move_and_slide(Vector2(getInputDirection().x * speed, y_velo))
	move_and_slide(velocity, Vector2(0, 1))
		
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
	if Input.is_action_just_pressed("ui_up"):
		y_velo = -800
		isOnGround = false
	if Input.is_action_pressed("ui_down"):
		$AnimationTree.set("parameters/isCrouching/current", 1)
		isCrouching = true
		canMove = false
		$defaultShape.disabled = true
		$crouchShape.disabled = false
	else:
		$AnimationTree.set("parameters/isCrouching/current", 0)
		isCrouching = false
		canMove = true
		$defaultShape.disabled = false
		$crouchShape.disabled = true
		
	
	if Input.is_action_just_pressed("close_game"):
		get_tree().quit()
	if Input.is_action_just_pressed("reload_scene"):
		get_tree().reload_current_scene()

func doGravity(delta):
	if y_velo > 0:
		$groundCheck.enabled = true
		if $groundCheck.is_colliding():
			isOnGround = true
		else:
			isOnGround = false
	else:
		$groundCheck.enabled = false
	y_velo -= GRAVITY * delta * -200
	if y_velo > 400:
		y_velo = 400
	print(y_velo)
