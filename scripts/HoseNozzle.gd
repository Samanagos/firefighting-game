extends Sprite2D

func hose_pointing(dir:Vector2):
	var hose_angle = atan2(dir.y, dir.x)
	rotation = hose_angle

