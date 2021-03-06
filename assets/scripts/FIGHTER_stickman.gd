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
	handleInputs() #siirrä tämä spawnerin puolelle
	
	doGravity(delta)
	doMovemet(delta) #ehkä tämäkin
	

		
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

func doAnimation(): #siisti jossain välissä
	if isOnGround:
		$AnimationTree.set("parameters/isOnGround/current", 1)
		if isMoving:
			$AnimationTree.set("parameters/isWalking/current", 1)
		else:
			$AnimationTree.set("parameters/isWalking/current", 0)
	else:
		$AnimationTree.set("parameters/isOnGround/current", 0)

func handleInputs(): #siirrä spawnerin puolelle, animaattori jätä
	if Input.is_action_just_pressed("ui_up") && isOnGround && canJump:
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
	if not isAttacking:
		$AnimationTree.set("parameters/isAttacking/current", 0)
	if canAttack:
		if Input.is_action_just_pressed("lp") && canAttack:
			isAttacking = true
			canAttack = false
			canMove = false
			$AnimationTree.set("parameters/isAttacking/current", 1)
		if Input.is_action_pressed("rp") && canAttack:
			isAttacking = true
			canAttack = false
			canMove = false
			$AnimationTree.set("parameters/isAttacking/current", 2)
		if Input.is_action_pressed("lk") && canAttack:
			isAttacking = true
			canAttack = false
			canMove = false
			$AnimationTree.set("parameters/isAttacking/current", 3)
		if Input.is_action_pressed("rk") && canAttack:
			isAttacking = true
			canAttack = false
			canMove = false
			$AnimationTree.set("parameters/isAttacking/current", 4)
		
	
	if Input.is_action_just_pressed("close_game"): #siirrä pois fighterin koodista skene manageriin
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

func doMovemet(delta):
	if getInputDirection().x != 0 && canMove:
		isMoving = true

	else:
		isMoving = false
	if canMove:
		velocity = move_and_slide(Vector2(getInputDirection().x * speed, y_velo))
		move_and_slide(velocity, Vector2(0, 1))
	else:
		velocity = move_and_slide(Vector2(0, y_velo))
		move_and_slide(velocity, Vector2(0, 1))

func doneAttack():
	isAttacking = false
	canAttack = true
	canMove = true
	$AnimationTree.set("parameters/isAttacking/current", 0)
	print("done attacking")

func _on_ljab_body_entered(body): #siisti hyökkäyskoodit
	if body is KinematicBody2D && body.has_method("takeDamage"):
		body.takeDamage(0, Vector2(30, -30), 0.5)


func _on_rjab_body_entered(body):
	if body is KinematicBody2D && body.has_method("takeDamage"):
		body.takeDamage(0, Vector2(40, -10), 0.3)
