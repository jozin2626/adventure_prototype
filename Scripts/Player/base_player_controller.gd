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

# Primarily to be used for sprite animations
var is_moving : bool = false

# Process input for movement
func get_input():
	var input = Vector2()
	if Input.is_action_pressed('right'):
		input.x += 1
	if Input.is_action_pressed('left'):
		input.x -= 1
	if Input.is_action_pressed('up'):
		input.y -= 1
	if Input.is_action_pressed('down'):
		input.y += 1
	return input
		
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
	var direction = get_input()
	process_movements(direction)
	move_and_slide()
