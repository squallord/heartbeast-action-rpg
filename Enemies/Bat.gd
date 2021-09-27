extends KinematicBody2D

var knockback = Vector2.ZERO
onready var stats = $Stats

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, 200 * delta)
	knockback = move_and_slide(knockback)

func _on_Hurtbox_area_entered(area):
	var direction = global_position - area.get_parent().global_position
	knockback = direction.normalized() * 100
	stats.health -= area.damage

func _on_Stats_no_health():
	queue_free()
