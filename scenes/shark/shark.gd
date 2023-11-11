class_name Shark

extends Area2D


const SPEED: int = 50
const MOVEMENT_FREQUENCY: float = 0.15
const MOVEMENT_AMPLITUED: float = 0.5
const POINT: int = 25
const TOTAL_SHARK_PIECES: int = 2
const DEATH_SOUND: AudioStream = preload("res://assets/enemies/shark/shark_death.ogg")
const object_piece_scene: PackedScene = preload("res://scenes/object_peice/object_piece.tscn")
const point_popup_scene: PackedScene = preload("res://scenes/point_popup/point_popup.tscn")

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


func spawn_shark_pieces() -> void:
	for i in range(TOTAL_SHARK_PIECES):
		var object_piece: ObjectPiece = object_piece_scene.instantiate() as ObjectPiece
		get_tree().current_scene.add_child(object_piece)
		object_piece.update_frame(i)
		object_piece.global_position = global_position


func spawn_point_popup() -> void:
	var point_popup: PointPopup = point_popup_scene.instantiate() as PointPopup
	get_tree().current_scene.add_child(point_popup)
	point_popup.update_point_label(POINT)
	point_popup.global_position = global_position
	


func _on_area_entered(area: Area2D) -> void:
	SoundManager.play_sound(DEATH_SOUND)
	spawn_point_popup()
	spawn_shark_pieces()
	update_score()
	area.queue_free()
	queue_free()


