class_name GameCamera

extends Camera2D

const MAX_Y_POS_OFFSET: float = 100.0
const OXYGEN_REFUEL_Y_POS: float = 32.0
const WEIGHT: int = 2

var target_position: Vector2 = Vector2.ZERO
var screen_size: Vector2 = Vector2.ZERO


func _ready() -> void:
	screen_size = get_viewport_rect().size
	target_position = global_position
	GameEvent.camera_follow_player.connect(_on_camera_follow_player)


func _on_camera_follow_player(player_position: Vector2) -> void:
	target_position.y = clamp(player_position.y, OXYGEN_REFUEL_Y_POS, screen_size.y + MAX_Y_POS_OFFSET/2.5)

	global_position = global_position.lerp(target_position, WEIGHT * get_physics_process_delta_time())
