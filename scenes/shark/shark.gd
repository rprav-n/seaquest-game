class_name Shark

extends Area2D


const SPEED: int = 50
const MOVEMENT_FREQUENCY: float = 0.15
const MOVEMENT_AMPLITUED: float = 0.5
const POINT: int = 25
const DEATH_SOUND: AudioStream = preload("res://assets/enemies/shark/shark_death.ogg")

var direction: Vector2 = Vector2.RIGHT


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(delta: float) -> void:
	direction.y = sin(global_position.x * MOVEMENT_FREQUENCY) * MOVEMENT_AMPLITUED
	global_position += direction * SPEED * delta


func flip_direction() -> void:
	direction = -direction
	animated_sprite_2d.flip_h = true


func update_score() -> void:
	Global.score += POINT;
	GameEvent.update_score.emit()


func _on_area_entered(area: Area2D) -> void:
	SoundManager.play_sound(DEATH_SOUND)
	update_score()
	area.queue_free()
	queue_free()


