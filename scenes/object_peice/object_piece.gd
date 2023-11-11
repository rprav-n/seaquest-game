class_name ObjectPiece

extends Sprite2D

var move_speed: float = 150.0
var velocity: Vector2 = Vector2.UP
var rotation_speed: int = 50
const WEIGHT: int = 6



func _ready() -> void:
	velocity = velocity.rotated(randf_range(0, 360))
	rotation_speed = randi_range(-100, 100)
	

func _physics_process(delta: float) -> void:
	global_position += velocity * delta * move_speed
	rotation_degrees += rotation_speed * delta
	move_speed = lerp(move_speed, 0.0, WEIGHT * delta)
	#scale = lerp(scale, Vector2.ZERO, WEIGHT * 0.25  * delta)


func update_frame(frame_value: int) -> void:
	frame = frame_value
