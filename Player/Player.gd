extends KinematicBody2D

const MAX_SPEED : int = 100
const ACCELERATION : int = 500
const FRICTION : int = 500

onready var velocity = Vector2.ZERO
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
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	if Input.is_action_just_pressed("ui_attack"):
		state = ATTACK
	
	velocity = move_and_slide(velocity)

func roll_state(delta):
	pass
	
func attack_state():
	velocity = Vector2.ZERO
	animationState.travel("Attack")
	pass

func finish_attacking():
	state = MOVE
