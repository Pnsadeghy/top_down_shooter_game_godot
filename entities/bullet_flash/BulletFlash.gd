extends Sprite2D

class_name BulletFlash

signal on_animation_end

@onready var animator = $AnimationPlayer

func show_flash():
	animator.play("flash")

func _on_animation_player_animation_finished(anim_name):
	animator.play("idle")
	on_animation_end.emit()
