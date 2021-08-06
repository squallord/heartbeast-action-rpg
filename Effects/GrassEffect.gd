extends Node2D


func _ready():
	var animatedSprite = $AnimatedSprite
	animatedSprite.play("Animate")
	pass

func _on_AnimatedSprite_animation_finished():
	queue_free()
	pass
