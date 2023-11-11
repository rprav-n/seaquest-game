class_name Person

extends Area2D

const SPEED: int = 40
const POINT: int = 50
const DEATH_SOUND: AudioStream = preload("res://assets/person/person_death.ogg")
const point_popup_scene: PackedScene = preload("res://scenes/point_popup/point_popup.tscn")

var direction: Vector2 = Vector2.RIGHT

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(delta: float) -> void:
	global_position += direction * SPEED * delta


func flip_direction() -> void:
	direction = -direction
	animated_sprite_2d.flip_h = true


func update_score() -> void:
	Global.score += POINT;
	GameEvent.update_score.emit()


func spawn_point_popup() -> void:
	var point_popup: PointPopup = point_popup_scene.instantiate() as PointPopup
	get_tree().current_scene.add_child(point_popup)
	point_popup.update_point_label(POINT)
	point_popup.global_position = global_position


func _on_area_entered(area: Area2D) -> void:
	if area is Player:
		if Global.saved_person_count < 7:
			queue_free()
			Global.saved_person_count += 1
			GameEvent.person_collected.emit()
			update_score()
			spawn_point_popup()
	else:
		# Bullet
		area.queue_free()
		SoundManager.play_sound(DEATH_SOUND)
		queue_free()
