extends Node2D

@export var player: RigidBody2D

func _ready():
	$Hose.add_point(Vector2.ZERO) # Self position.

var enabled = false
func _process(_delta):
	if $DetectShape.overlaps_body(player):
		if Input.is_action_just_released("interact"):
			enabled = true
	
	if $Hose.get_point_count() >= 2:
		$Hose.remove_point(1)
	
	if enabled:
		$Hose.add_point(player.position - position)
