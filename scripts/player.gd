extends RigidBody2D

@export_category("Move Variables")
@export var speed: float = 25;
@export var max_speed: float = 750;
@export var jump_power: float = 500;

var grounded: bool = false

const mult = 100
@export_category("Spray Variables")
@export var spray_power: float = 30;
@export var discharge_speed: float = 110
@export var charge_speed: float = 40
@export var max_pressure: float = 100
var pressure: float = max_pressure
var spraying: bool = false
var spray_intensity: float = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	lock_rotation = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# Grounded:
	if $GroundLeft.is_colliding() || $GroundRight.is_colliding(): grounded = true
	else: grounded = false

	pressure = clampf(pressure + delta * charge_speed, 0, max_pressure)
	print(pressure)

	movement(delta)

	# Spray stuff

	var mouse_position = $Cam.get_viewport().get_mouse_position()
	var spray_direction = (mouse_position - $Cam.get_viewport_rect().size/2).normalized()

	$HoseNozzle.hose_pointing(spray_direction)
	if Input.is_action_just_pressed("spray"):
		spraying = true
	elif Input.is_action_just_released("spray"):
		spraying = false
		$HoseNozzle/WaterParticles.amount_ratio = 0

	if spraying:
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
	if pressure > 1:
		apply_central_impulse(-spray_direction * spray_power * mult * delta)

		$HoseNozzle/WaterParticles.amount_ratio = spray_intensity
		pressure = clampf(pressure - delta * discharge_speed, 0, max_pressure)
		spray_intensity = pressure / 100.0
