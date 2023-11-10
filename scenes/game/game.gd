class_name Game

extends Node

@export var background_color: Color


func _ready() -> void:
	RenderingServer.set_default_clear_color(background_color)
