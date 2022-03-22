extends KinematicBody2D
var notWalking = true
var speed = 300
var velocity = Vector2()

func _physics_process(delta):
	if getInputVector() != Vector2(0, 0):
		notWalking = false
		velocity = move_and_slide(getInputVector() * speed)
	else:
		notWalking = true
	
	if notWalking:
		$AnimationTree.set("parameters/is_moving/current", 0)
	elif notWalking == false:
		$AnimationTree.set("parameters/is_moving/current", 1)

func getInputVector(): 
	var inputX = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var inputY = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	return(Vector2(inputX, inputY))
