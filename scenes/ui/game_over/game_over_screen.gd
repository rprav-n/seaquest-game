class_name GameOverScreen

extends Control

const GAME_OVER_SOUND: AudioStream = preload("res://assets/player/game_over.ogg")

@onready var score_label: Label = %ScoreLabel
@onready var high_score_label: Label = %HighScoreLabel
@onready var game_over_delay: Timer = $GameOverDelay
@onready var retry_button: Button = %RetryButton


func _ready() -> void:
	visible = false
	GameEvent.game_over.connect(_on_game_over)


func set_high_score(score: int) -> void:
	if score > Global.high_score:
		Global.high_score = score


func _on_game_over() -> void:
	game_over_delay.start()
	score_label.text = "Score: " + str(Global.score)
	set_high_score(Global.score)
	high_score_label.text = "High Score: " + str(Global.high_score)


func _on_retry_button_pressed() -> void:
	get_tree().reload_current_scene()


func _on_game_over_delay_timeout() -> void:
	visible = true
	retry_button.grab_focus()
	SoundManager.play_sound(GAME_OVER_SOUND)


func _on_quit_button_pressed() -> void:
	get_tree().quit()
