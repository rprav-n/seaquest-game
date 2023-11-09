class_name Player

extends Area2D

enum State {DEFAULT, FULL_REFUEL, LESS_REFUEL}

const SPEED: Vector2 = Vector2(100, 80)
const BULLET_OFFSET: int = 5
const OXYGEN_DECREASE_SPEED: float = 2.5
const OXYGEN_INCREASE_SPEED: float = 20.0

var velocity: Vector2 = Vector2.ZERO
var can_shoot: bool = true

var state: State = State.DEFAULT

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var reload_timer: Timer = $ReloadTimer
@onready var bullet_scene: PackedScene = preload("res://scenes/bullet/bullet.tscn")
@onready var bullets: Node2D = get_tree().get_first_node_in_group("bullets") as Node2D


func _process(_delta: float) -> void:
	if state == State.DEFAULT:
		handle_movement()
		change_direction()
		shoot_bullet()
		lose_oxygen()
	elif state == State.LESS_REFUEL:
		refuel_oxygen()
	elif state == State.FULL_REFUEL:
		refuel_oxygen()


func _physics_process(_delta: float) -> void:
	if state == State.DEFAULT:
		movement()


func movement():
	global_position += velocity * SPEED * get_physics_process_delta_time()


func handle_movement() -> void:
	velocity.x = Input.get_axis("move_left", "move_right")
	velocity.y = Input.get_axis("move_up", "move_down")
	velocity = velocity.normalized()


func change_direction() -> void:
	if velocity.x != 0:
		animated_sprite_2d.flip_h = true if velocity.x < 0 else false
		collision_shape_2d.global_position.x = global_position.x - 3.0 if animated_sprite_2d.flip_h else global_position.x + 0.5 


func shoot_bullet() -> void:
	if Input.is_action_pressed("shoot") && can_shoot:
		var bullet: Bullet = bullet_scene.instantiate() as Bullet
		bullets.add_child(bullet)
		
		var offset: Vector2 = Vector2(BULLET_OFFSET, 0)
		
		if animated_sprite_2d.flip_h:
			bullet.flip_direction()
			offset.x *= -1
			
		bullet.global_position = global_position + offset
		
		can_shoot = false
		reload_timer.start()


func lose_oxygen() -> void:
	var oxygen_decrease_delta: float = OXYGEN_DECREASE_SPEED * get_process_delta_time()
	Global.oxygen_level = move_toward(Global.oxygen_level, 0, oxygen_decrease_delta)


func refuel_oxygen() -> void:
	Global.oxygen_level += OXYGEN_INCREASE_SPEED * get_process_delta_time()
	if Global.oxygen_level >= 100.0:
		state = State.DEFAULT


func _on_reload_timer_timeout() -> void:
	can_shoot = true


func _on_area_entered(_area: Area2D) -> void:
	queue_free()


func _on_oxygen_area_full_crew_oxygen_refuel():
	state = State.FULL_REFUEL


func _on_oxygen_area_less_crew_oxygen_refuel():
	state = State.LESS_REFUEL
