extends Area2D

signal on_health_changed(health: int)

@export var type: Constants.CharacterType

@export var max_health := 1
var current_health := 0

func _ready():
	current_health = max_health

func _on_area_entered(area):
	if current_health <= 0: return
	
	if area is Bullet:
		match type:
			Constants.CharacterType.Player:
				if !area.is_in_group(Constants.PLAYER_BULLET_GROUP): return
				pass
			Constants.CharacterType.Enemy:
				if !area.is_in_group(Constants.ENEMY_BULLET_GROUP): return
				pass
			Constants.CharacterType.Both:
				if !area.is_in_group(Constants.PLAYER_BULLET_GROUP) and !area.is_in_group(Constants.ENEMY_BULLET_GROUP): return
				pass
		
		print("hit")
		current_health -= area.damage
		area.queue_free()
		on_health_changed.emit(current_health)
