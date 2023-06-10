extends Node

const PLAYER_BULLET_GROUP = "player_bullet"
const ENEMY_BULLET_GROUP = "enemy_bullet"

enum CharacterType {
	Player,
	Enemy,
	Both
}

enum EnemyAIStates {
	DIE,
	PATROL,
	ENGAGE,
	LOOKING
}
