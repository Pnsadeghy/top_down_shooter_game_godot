extends Camera2D

@onready var animator: AnimationPlayer = $Animator

func _ready():
	Events.shake_screen.connect(on_shake)

func on_shake():
	animator.play("shake")
