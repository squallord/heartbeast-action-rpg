extends KinematicBody2D

export(int) var MAX_SPEED = 100
export(int) var ROLL_SPEED  = 120
export(int) var ACCELERATION = 500
export(int) var FRICTION = 500

onready var velocity = Vector2.ZERO
onready var roll_direction = Vector2.DOWN
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

onready var state = MOVE

enum {
	MOVE,
	ROLL,
	ATTACK,
}

func _ready():
	animationTree.active = true

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state(delta)
		ATTACK:
			attack_state()
	

func move_state(delta):
	var input_vector : Vector2 = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		roll_direction = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	if Input.is_action_just_pressed("ui_attack"):
		state = ATTACK
		
	if Input.is_action_just_pressed("ui_roll"):
		state = ROLL
	
	move()
	
func move():
	velocity = move_and_slide(velocity)

func roll_state(delta):
	velocity = roll_direction * ROLL_SPEED
	animationState.travel("Roll")
	move()
	pass
	
func attack_state():
	velocity = Vector2.ZERO
	animationState.travel("Attack")
	pass

func finish_attacking():
	state = MOVE

func finish_rolling():
	velocity /= 2
	state = MOVE
