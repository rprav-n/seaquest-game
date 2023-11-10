class_name Player

extends Area2D

enum State {DEFAULT, FULL_REFUEL, OXYGEN_REFUEL}

const SPEED: Vector2 = Vector2(100, 80)
const BULLET_OFFSET: int = 5

const OXYGEN_DECREASE_SPEED: float = 2.5
const OXYGEN_INCREASE_SPEED: float = 20.0
const OXYGEN_REFUEL_Y_POS: float = 32.0

var velocity: Vector2 = Vector2.ZERO
var can_shoot: bool = true

var screen_size: Vector2 = Vector2.ZERO

var state: State = State.DEFAULT

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var reload_timer: Timer = $ReloadTimer
@onready var bullet_scene: PackedScene = preload("res://scenes/bullet/bullet.tscn")
@onready var bullets: Node2D = get_tree().get_first_node_in_group("bullets") as Node2D
@onready var unload_person_timer: Timer = $UnloadPersonTimer


func _ready() -> void:
	screen_size = get_viewport_rect().size


func _process(_delta: float) -> void:
	if state == State.DEFAULT:
		handle_movement()
		change_direction()
		shoot_bullet()
		lose_oxygen()
	elif state == State.OXYGEN_REFUEL:
		move_to_shore_line()
		refuel_oxygen()
	elif state == State.FULL_REFUEL:
		move_to_shore_line()


func _physics_process(_delta: float) -> void:
	if state == State.DEFAULT:
		movement()


func movement():
	global_position += velocity * SPEED * get_physics_process_delta_time()
	clamp_position()


func clamp_position() -> void:
	global_position.x = clamp(global_position.x, 0.0, screen_size.x)
	global_position.y = clamp(global_position.y, OXYGEN_REFUEL_Y_POS, screen_size.y)


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


func move_to_shore_line() -> void:
	global_position.y = move_toward(global_position.y, OXYGEN_REFUEL_Y_POS, SPEED.y * get_physics_process_delta_time())


func remove_one_person() -> void:
	if Global.saved_person_count > 0:
		Global.saved_person_count -= 1 
	GameEvent.person_collected.emit()


func _on_reload_timer_timeout() -> void:
	can_shoot = true


func _on_area_entered(_area: Area2D) -> void:
	pass
	#queue_free()


func _on_oxygen_area_full_crew_oxygen_refuel() -> void:
	unload_person_timer.start()
	state = State.FULL_REFUEL


func _on_oxygen_area_less_crew_oxygen_refuel() -> void:
	state = State.OXYGEN_REFUEL
	remove_one_person()


func _on_unload_person_timer_timeout() -> void:
	remove_one_person()
	if Global.saved_person_count <= 0:
		state = State.OXYGEN_REFUEL
		unload_person_timer.stop()
