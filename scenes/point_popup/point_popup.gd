class_name PointPopup

extends Node2D

const SPEED: int = 50

@onready var point_label: Label = $PointLabel


func _physics_process(delta: float) -> void:
	global_position.y -= SPEED * delta


func update_point_label(point: int) -> void:
	point_label.text = str(point)
