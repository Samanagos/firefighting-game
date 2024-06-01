extends RigidBody2D

@export var speed: float = 25;
@export var max_speed: float = 750;
@export var x_damp: float = 750;
@export var jump_power: float = 500;
@export var spray_power: float = 500;

var grounded: bool = false

const mult = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	lock_rotation = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# Grounded:
	if $GroundLeft.is_colliding() || $GroundRight.is_colliding(): grounded = true
	else: grounded = false

	movement(delta)

	# Spray stuff
	var mouse_position = get_viewport().get_mouse_position()
	var spray_direction = (mouse_position - global_position).normalized()

	$HoseNozzle.hose_pointing(spray_direction)
	if Input.is_action_pressed("spray"):
		hose_spray(delta, spray_direction)

# Handle the moving of the character
func movement(delta: float):
	# Extract delta vel from impulse. I = pv, p = momentum
	# Then scale v to be under max_speed. Then apply Impulse.
	if Input.is_action_pressed("move_right"):
		var d_imp = Vector2.RIGHT * speed * delta * mult
		var vel = d_imp / mass

		if (vel + linear_velocity).length() > max_speed:
			vel = vel.normalized() * (clamp(max_speed - linear_velocity.length(), 0, max_speed))
			d_imp = mass * vel

		apply_central_impulse(d_imp)
	elif Input.is_action_pressed("move_left"):
		var d_imp = Vector2.LEFT * speed * delta * mult
		var vel = d_imp / mass

		if (vel + linear_velocity).length() > max_speed:
			vel = vel.normalized() * (clamp(max_speed - linear_velocity.length(), 0, max_speed))
			d_imp = mass * vel

		apply_central_impulse(d_imp)

	if grounded && Input.is_action_just_pressed("move_jump"):
		apply_central_impulse(Vector2.UP * jump_power * delta * mult)

func hose_spray(delta: float, spray_direction):
	apply_central_impulse(-spray_direction * spray_power * mult * delta)
	print(spray_direction)
