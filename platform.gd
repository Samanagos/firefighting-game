extends StaticBody2D

@export var extinguished = true

func _ready():
	$FireArea.extinguished = extinguished
	$FireArea.fire_toggle()
	
