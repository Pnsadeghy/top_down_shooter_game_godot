extends Area2D

class_name Bullet

@export var speed := 300
@export var damage := 1

var movement_vector = Vector2.DOWN

func _physics_process(delta):
	global_position += movement_vector.rotated(rotation) * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_body_entered(body):
	queue_free()
