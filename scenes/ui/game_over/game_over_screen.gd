class_name GameOverScreen

extends Control

@onready var score_label: Label = %ScoreLabel
@onready var high_score_label: Label = %HighScoreLabel
@onready var game_over_delay: Timer = $GameOverDelay


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


func _on_game_over_delay_timeout():
	visible = true
