class_name Player

extends Area2D

const SPEED: Vector2 = Vector2(100, 80)
const BULLET_OFFSET: int = 5

var velocity: Vector2 = Vector2.ZERO
var can_shoot: bool = true

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var reload_timer: Timer = $ReloadTimer
@onready var bullet_scene: PackedScene = preload("res://scenes/bullet/bullet.tscn")


func _physics_process(delta: float) -> void:
	handle_movement()
	change_direction()
	shoot_bullet()
	global_position += velocity * SPEED * delta
	

func handle_movement() -> void:
	velocity.x = Input.get_axis("move_left", "move_right")
	velocity.y = Input.get_axis("move_up", "move_down")
	velocity = velocity.normalized()


func change_direction() -> void:
	if velocity.x != 0:
		animated_sprite_2d.flip_h = true if velocity.x < 0 else false


func shoot_bullet() -> void:
	if Input.is_action_pressed("shoot") && can_shoot:
		var bullet: Bullet = bullet_scene.instantiate() as Bullet
		get_tree().current_scene.add_child(bullet)
		
		var offset: Vector2 = Vector2(BULLET_OFFSET, 0)
		
		if animated_sprite_2d.flip_h:
			bullet.flip_direction()
			offset.x *= -1
			
		bullet.global_position = global_position + offset
		
		can_shoot = false
		reload_timer.start()


func _on_reload_timer_timeout() -> void:
	can_shoot = true
