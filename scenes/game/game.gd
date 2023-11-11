class_name Game

extends Node

@export var background_color: Color


func _ready() -> void:
	reset_globals()
	RenderingServer.set_default_clear_color(background_color)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()


func reset_globals() -> void:
	Global.saved_person_count = 0
	Global.oxygen_level = 100.0
	Global.score = 0

