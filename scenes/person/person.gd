class_name Person

extends Area2D

const SPEED: int = 40

var direction: Vector2 = Vector2.RIGHT

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(delta: float) -> void:
	global_position += direction * SPEED * delta


func flip_direction() -> void:
	direction = -direction
	animated_sprite_2d.flip_h = true


func _on_area_entered(area: Area2D) -> void:
	if area is Player:
		Global.saved_person_count += 1
		GameEvent.person_collected.emit()
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
