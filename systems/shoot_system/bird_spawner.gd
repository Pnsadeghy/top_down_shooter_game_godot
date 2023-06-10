extends Node

signal on_spawn_bird(bird: Bird, remains: int)

@export var max_bird := 3
var bird_remains := 0

func _ready():
	bird_remains = get_children().size()

func spawn_bird():
	if bird_remains == 0: return
	var bird = get_child(0)
	bird_remains -= 1
	on_spawn_bird.emit(bird as Bird, bird_remains)
	
