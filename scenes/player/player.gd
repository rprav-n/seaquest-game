class_name Player

extends Area2D

const SPEED: Vector2 = Vector2(100, 80)

var velocity: Vector2 = Vector2.ZERO

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(delta: float) -> void:
	handle_movement()
	change_direction()
	global_position += velocity * SPEED * delta
	

func handle_movement() -> void:
	velocity.x = Input.get_axis("move_left", "move_right")
	velocity.y = Input.get_axis("move_up", "move_down")
	velocity = velocity.normalized()

func change_direction() -> void:
	if velocity.x != 0:
		animated_sprite_2d.flip_h = true if velocity.x < 0 else false
