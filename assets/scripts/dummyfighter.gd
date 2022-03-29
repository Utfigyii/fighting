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
var stunned = false

func _physics_process(delta):
	handleInputs()
	
	doGravity(delta)
	doMovemet(delta)
	
	
func getInputDirection():
	return Vector2(0, 0)
	
func handleInputs():
	pass

func doGravity(delta):
	print(y_velo)
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
	if !stunned:
		if canMove:
			velocity = move_and_slide(Vector2(getInputDirection().x * speed, y_velo))
			move_and_slide(velocity, Vector2(0, 1))
		else:
			velocity = move_and_slide(Vector2(0, y_velo))
			move_and_slide(velocity, Vector2(0, 1))
	else:
		velocity = move_and_slide(Vector2(velocity.x, -y_velo))
		doGravity(delta)
		
func doneAttack():
	pass

func takeDamage(damage, knockback, stunTime):
	velocity = knockback
	y_velo = knockback.y
	stunned = true
	$stunTimer.start(stunTime)
	$groundCheck.enabled = false
	print("iam hit", knockback)


func _on_stunTimer_timeout():
	stunned = false
	print("not stunned anymore")
