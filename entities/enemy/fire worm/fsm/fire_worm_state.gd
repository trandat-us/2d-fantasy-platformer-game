extends EnemyState
class_name FireWormState

var fire_worm: FireWorm:
	get:
		return enemy
var wall_detector: RayCast2D
var floor_detector: RayCast2D
