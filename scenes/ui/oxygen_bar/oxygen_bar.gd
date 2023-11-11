class_name OxygenBar

extends Node2D

const WEIGHT: int = 6
const OXYGEN_ALERT: AudioStream = preload("res://assets/user_interface/oxygen-bar/oxygen_alert.ogg")

var previous_amount: int = 0

@onready var texture_progress: TextureProgressBar = $TextureProgress
@onready var flash_timer: Timer = $FlashTimer



func _process(_delta: float) -> void:
	texture_progress.value = Global.oxygen_level
	
	var amount_rounded: int = round(Global.oxygen_level)
	
	if amount_rounded == previous_amount:
		return
	
	match amount_rounded:
		25:
			alert(1.25, 5)
		15:
			alert(1.3, 7)
		10:
			alert(1.35, 10)
		7:
			alert(1.4, 15)
		5:
			alert(1.5, 20)
		2:
			alert(1.6, 25)
	
	previous_amount = amount_rounded
	

func _physics_process(delta: float) -> void:
	scale = lerp(scale, Vector2.ONE, WEIGHT * delta)
	rotation_degrees = lerp(rotation_degrees, 0.0, WEIGHT * delta)


func alert(scale_value: float, rotation_value: int) -> void:
	scale = Vector2(scale_value, scale_value)
	rotation_degrees = randf_range(-rotation_value, rotation_value)
	modulate = Color(50, 50, 50)
	flash_timer.start()
	SoundManager.play_sound(OXYGEN_ALERT)


func _on_flash_timer_timeout() -> void:
	modulate = Color(1, 1, 1)
