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



func _on_screenshot_timer_timeout() -> void:
	var img = get_viewport().get_texture().get_image()
	var timestamp: int = int(Time.get_unix_time_from_system())

	img.save_png("res://build/screenshots/screenshot_" + str(timestamp) + ".png")
