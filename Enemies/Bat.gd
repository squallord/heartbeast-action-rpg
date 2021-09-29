extends KinematicBody2D

export(int) var MAX_SPEED = 100
export(int) var ROLL_SPEED  = 120
export(int) var ACCELERATION = 500
export(int) var FRICTION = 200

var knockback = Vector2.ZERO
onready var stats = $Stats
const EnemyDeathEffect = preload("res://Enemies/EnemyDeathEffect.tscn")

enum {
	IDLE,
	WANDER,
	CHASE
}

var state = IDLE
var velocity = Vector2.ZERO

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			pass
		WANDER:
			pass
		CHASE:
			pass
			
func seek_player():
	pass

func _on_Hurtbox_area_entered(area):
	var direction = global_position - area.get_parent().global_position
	knockback = direction.normalized() * 100
	stats.health -= area.damage

func _on_Stats_no_health():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
