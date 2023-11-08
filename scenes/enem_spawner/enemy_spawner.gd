class_name EnemySpawner

extends Node2D

const TOTAL_SPAWN_COUNT: int = 4

@onready var spawn_timer: Timer = $SpawnTimer
@onready var left_spawner: Node = $LeftSpawner
@onready var right_spawner: Node = $RightSpawner
@onready var shark_scene: PackedScene = preload("res://scenes/shark/shark.tscn")

var used_spawn_points: Array[int] = []

func _on_spawn_timer_timeout() -> void:
	spawn_sharks()
	used_spawn_points.clear()


func spawn_sharks() -> void:	
	for count in TOTAL_SPAWN_COUNT:
		var available_spawn_points: Array[int] = []
		var selected_spawner: Node = left_spawner
		var spawn_right: bool = bool(randi_range(0, 1))
		
		if spawn_right:
			selected_spawner = right_spawner
		
		for i in range(1, 5):
			if !used_spawn_points.has(i):
				available_spawn_points.append(i)
	
		var random_spawn_index: int = randi_range(0, available_spawn_points.size() - 1)
		var selected_spawner_point_number: int = available_spawn_points[random_spawn_index]
		used_spawn_points.append(selected_spawner_point_number)
		
		var marker_2d: Marker2D = selected_spawner.get_node(str(selected_spawner_point_number)) as Marker2D
		var should_flip: bool = false
		if spawn_right:
			should_flip = true
		
		create_shark(marker_2d.global_position, should_flip)


func create_shark(shark_position: Vector2, should_flip: bool) -> void:
	var shark: Shark = shark_scene.instantiate() as Shark
	get_parent().add_child(shark)
	
	if should_flip:
		shark.flip_direction()
	
	shark.global_position = shark_position
	
