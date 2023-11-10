class_name UIScreen

extends CanvasLayer

@onready var score_label: Label = %ScoreLabel


func _ready() -> void:
	GameEvent.update_score.connect(_on_update_score)


func _on_update_score() -> void:
	score_label.text = str(Global.score)
