class_name Bullet

extends Area2D

const SPEED: int = 400

var direction: Vector2 = Vector2.RIGHT

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _ready():
	rotation_degrees = randf_range(-3, 3)
	direction = direction.rotated(deg_to_rad(rotation_degrees))


func _physics_process(delta: float) -> void:
	global_position += direction * SPEED * delta


func flip_direction() -> void:
	direction = -direction
	animated_sprite_2d.flip_h = !animated_sprite_2d.flip_h


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
