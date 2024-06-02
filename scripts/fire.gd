extends Area2D

@export var extinguished: bool = true
@export var rekindle: bool = false
@export var rekindle_time: float = 3
var rekindle_timer_sec: float = rekindle_time

var water_name: String = "SprayColArea"

func fire_toggle():
	if extinguished:
		$FireParticle.emitting = false
	else:
		$FireParticle.emitting = true


func _process(delta):
	var areas: Array[Area2D] = get_overlapping_areas()
	if areas.size() > 0:
		for a in areas:
			print(a.name)
			
			if a.name == water_name && !extinguished:
				print("HSBIHjdOACIHB WCHDBD NABWHBFIJHVBWI DJ")
				$FireParticle.emitting = false
				extinguished = true
				rekindle = false
			elif a.name.contains(self.name) && !self.extinguished && a.extinguished:
				a.rekindle = true
	
	if !$FireParticle.emitting && rekindle:
		rekindle_timer_sec = clampf(rekindle_timer_sec - delta, 0, rekindle_time)
	
	if rekindle_timer_sec == 0:
		$FireParticle.emitting = true
		rekindle = false
		extinguished = false
		rekindle_timer_sec = rekindle_time

