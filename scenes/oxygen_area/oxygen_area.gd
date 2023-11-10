class_name OxygenArea

extends Area2D

signal full_crew_oxygen_refuel
signal less_crew_oxygen_refuel

const MAX_PERSON_COUNT: int = 7

func _on_area_entered(_area: Area2D):
	if Global.saved_person_count >= MAX_PERSON_COUNT:
		full_crew_oxygen_refuel.emit()
	else:
		less_crew_oxygen_refuel.emit()
