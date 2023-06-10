extends CharacterBody2D

@export var move_speed := 200

var move_velocity = Vector2.ZERO

@onready var weapon = $Weapon

func _process(delta):
	move_velocity.x = Input.get_axis("left", "right")
	move_velocity.y = Input.get_axis("up", "down")

func _physics_process(delta):
	look_at(get_global_mouse_position())
	
	velocity = move_velocity.normalized() * move_speed
	move_and_slide()

# get inputs that not handled with others
func _unhandled_input(event):
	if event.is_action_released("shoot"):
		on_shoot()

func on_shoot():
	if weapon.can_shoot():
		weapon.shoot()
		Events.shake_screen.emit()
