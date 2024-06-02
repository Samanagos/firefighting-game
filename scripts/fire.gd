extends Area2D

var to_extinguish: bool = false
var extinguished: bool = true
var rekindle: bool = false
var rekindle_timer_sec: float = 1.5

@export var water_name: String = ""

func _process(delta):
	var areas: Array[Area2D] = get_overlapping_areas()
	if areas.size() > 0:
		for a in areas:
			if a.name == water_name && !extinguished:
				to_extinguish = true
			elif a.name.contains(self.name) && extinguished:
				a.rekindle = true
	
	if to_extinguish && !extinguished:
		$FireParticle.amount_ratio = clampf($FireParticle.amount_ratio - delta, 0, 1)
		
		if $FireParticle.amount_ratio == 0:
			extinguished = true
	
	if rekindle:
		rekindle_timer_sec = clampf(rekindle_timer_sec - delta, 0, 10)
		
		if rekindle_timer_sec == 0:
			$FireParticle.amount_ratio = clampf($FireParticle.amount_ratio + delta, 0, 1)
		
		if $FireParticle.amount_ratio == 1:
			rekindle = false
			extinguished = false
			to_extinguish = false
