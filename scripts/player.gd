extends RigidBody2D

@export var speed: float = 25;
@export var jump_power: float = 500;
@export var spray_power: float = 500;

@export var grounded: bool = false

const mult = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	lock_rotation = true
	$GroundCol.body_entered.connect(func(_area): grounded = true)
	$GroundCol.body_exited.connect(func(_area): grounded = false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	print(grounded)
	if Input.is_action_pressed("move_right"):
		apply_central_impulse(Vector2.RIGHT * speed * delta * mult)
	elif Input.is_action_pressed("move_left"):
		apply_central_impulse(Vector2.LEFT * speed * delta * mult)
	
	if grounded && Input.is_action_just_pressed("move_jump"):
		apply_central_impulse(Vector2.UP * jump_power * delta * mult)
	
	# Spray stuff
	var mouse_position = get_viewport().get_mouse_position()
	var spray_direction = (mouse_position - global_position).normalized()
	
	$HoseNozzle.hose_pointing(spray_direction)
	if Input.is_action_pressed("spray"):
		hose_spray(delta, spray_direction)
		
func hose_spray(delta: float, spray_direction):
	apply_central_impulse(-spray_direction * spray_power * mult * delta)
	print(spray_direction)
