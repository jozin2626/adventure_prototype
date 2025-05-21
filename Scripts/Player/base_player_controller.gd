extends CharacterBody2D

# Speed of character
@export var speed : float = 50.0:
	get:
		return speed
	set(speed_in):
		speed = speed_in
# Accelleration of character
@export var accel : float = 1.0:
	get:
		return accel
	set(accel_in):
		accel = accel_in
@export var friction : float = 0.1:
	get:
		return friction
	set(friction_in):
		friction = friction_in


# variables used for animation
var is_moving : bool = false
enum Direction {LEFT, RIGHT, UP, DOWN}
var last_movement : Direction
@onready var animator = $Animator

func _ready() -> void:
	await get_tree().physics_frame
	animator.play('default')

# Process input for movement
# TODO replace 'idle_(direction) with actual movement animations when sprites are finished
func get_movement_input():
	var input = Vector2()
	if Input.is_action_pressed('right'):
		input.x += 1
		animator.play('idle_right')
		last_movement = Direction.RIGHT
	if Input.is_action_pressed('left'):
		input.x -= 1
		animator.play('idle_left')
		last_movement = Direction.LEFT
	if Input.is_action_pressed('up'):
		input.y -= 1
		animator.play('idle_up')
		last_movement = Direction.UP
	if Input.is_action_pressed('down'):
		input.y += 1
		animator.play('idle_down')
		last_movement = Direction.DOWN
	return input
	
# Determine which idle animations to be played based on last direction moved
func process_idle_animations() -> void:
	match last_movement:
		Direction.RIGHT:
			animator.play('idle_right')
		Direction.LEFT:
			animator.play('idle_left')
		Direction.UP:
			animator.play('idle_up')
		Direction.DOWN:
			animator.play('idle_down')
	
# handle any attack inputs
func get_interactive_input():
	if Input.is_action_pressed("attack"):
		pass
		
# Process movements
func process_movements(direction: Vector2) -> void:
	if direction.length() > 0:
		is_moving = true
		velocity = velocity.lerp(direction.normalized() * get('speed'), get('accel'))
	else:
		is_moving = false
		velocity = velocity.lerp(Vector2.ZERO, get('friction'))

# Driver function for player movements
func _physics_process(delta: float) -> void:
	# Get movement direction
	var direction = get_movement_input()
	process_movements(direction)
	process_idle_animations()
	move_and_slide()
