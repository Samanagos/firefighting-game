extends RigidBody2D

@export var speed: float = 20000;
@export var jump_power: float = 500;

# Called when the node enters the scene tree for the first time.
func _ready():
	lock_rotation = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var move: Vector2 = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		move += (Vector2.RIGHT * speed * delta)
		if Input.is_action_just_pressed("dash"):
			move = (Vector2.RIGHT * speed * 15 * delta)
	elif Input.is_action_pressed("move_left"):
		move += (Vector2.LEFT * speed * delta)
		if Input.is_action_just_pressed("dash"):
			move = (Vector2.LEFT * speed * 15 * delta)
	
	if Input.is_action_just_pressed("move_jump"):
		linear_velocity.y = -jump_power
	
	linear_velocity.x = move.x
	if Input.is_action_pressed("water"):
		hose_spray(delta)
		
func hose_spray(delta: float):
	var mouse_position = get_viewport().get_mouse_position()
	var spray_direction = (mouse_position - global_position).normalized()
	apply_central_force(-spray_direction * 5000)
	print(spray_direction)
