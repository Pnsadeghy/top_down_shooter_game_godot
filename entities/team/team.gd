extends CharacterBody2D

@onready var ai: EnemyAI = $AI

var is_alive := true

func _on_hittable_system_on_health_changed(health):
	is_alive = health > 0
	if !is_alive:
		ai.on_die()
