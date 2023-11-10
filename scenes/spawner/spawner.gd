class_name Spawners

extends Node2D

const TOTAL_SPAWN_COUNT: int = 4

var shark_scene: PackedScene = preload("res://scenes/shark/shark.tscn")
var person_scene: PackedScene = preload("res://scenes/person/person.tscn")

@onready var left_spawner: Node2D = $LeftSpawner
@onready var right_spawner: Node2D = $RightSpawner
@onready var persons: Node2D = get_tree().get_first_node_in_group("persons") as Node2D
@onready var sharks: Node2D = get_tree().get_first_node_in_group("sharks") as Node2D

var used_spawn_points: Array[int] = []


func get_random_spanwner() -> Node:
	var selected_spawner: Node = left_spawner
	var spawn_right: bool = bool(randi_range(0, 1))
	
	if spawn_right:
		selected_spawner = right_spawner
	return selected_spawner


func spawn_sharks() -> void:	
	for count in TOTAL_SPAWN_COUNT:
		var available_spawn_points: Array[int] = []
		
		var selected_spawner: Node = get_random_spanwner()
		var should_spawn_right: bool = true if selected_spawner == right_spawner else false
		
		for i in range(1, 5):
			if !used_spawn_points.has(i):
				available_spawn_points.append(i)
	
		var random_spawn_index: int = randi_range(0, available_spawn_points.size() - 1)
		var selected_spawner_point_number: int = available_spawn_points[random_spawn_index]
		used_spawn_points.append(selected_spawner_point_number)
		
		var marker_2d: Marker2D = selected_spawner.get_node(str(selected_spawner_point_number)) as Marker2D
		
		create_shark(marker_2d.global_position, should_spawn_right)


func create_shark(shark_position: Vector2, should_flip: bool) -> void:
	var shark: Shark = shark_scene.instantiate() as Shark
	sharks.add_child(shark)
	
	if should_flip:
		shark.flip_direction()
	
	shark.global_position = shark_position
	

func spawn_person() -> void:
	var selected_spawner: Node = get_random_spanwner()
	var should_spawn_right: bool = true if selected_spawner == right_spawner else false
	
	var selected_spawn_point_number: int = randi_range(1, 4)
	var marker_2d: Marker2D = selected_spawner.get_node(str(selected_spawn_point_number)) as Marker2D
	
	create_person(marker_2d.global_position, should_spawn_right)


func create_person(person_position: Vector2, should_flip: bool) -> void:
	var person: Person = person_scene.instantiate() as Person
	persons.add_child(person)
	
	person.global_position = person_position
	if should_flip:
		person.flip_direction()


func _on_spawn_shark_timer_timeout() -> void:
	spawn_sharks()
	used_spawn_points.clear()


func _on_spawn_person_timer_timeout() -> void:	
	spawn_person()
	

