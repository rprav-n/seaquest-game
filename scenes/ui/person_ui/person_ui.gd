class_name PersonUI

extends Sprite2D

const EMPTY_TEXTURE: Texture = preload("res://assets/user_interface/people-count/person_empty_ui.png")
const FULL_TEXTURE: Texture = preload("res://assets/user_interface/people-count/person_ui.png")

@export var order_number: int


func _ready() -> void:
	GameEvent.person_collected.connect(_on_person_collected)


func _on_person_collected() -> void:
	if Global.saved_person_count >= order_number:
		texture = FULL_TEXTURE

