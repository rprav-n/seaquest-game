class_name Shark

extends Area2D


const SPEED: int = 50
const MOVEMENT_FREQUENCY: float = 0.15
const MOVEMENT_AMPLITUED: float = 0.5

var direction: Vector2 = Vector2.RIGHT


func _physics_process(delta: float) -> void:
	direction.y = sin(global_position.x * MOVEMENT_FREQUENCY) * MOVEMENT_AMPLITUED
	global_position += direction * SPEED * delta


func _on_area_entered(area: Area2D) -> void:
	area.queue_free()
	queue_free()
