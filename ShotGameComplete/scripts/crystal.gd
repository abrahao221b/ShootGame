extends RigidBody2D



# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	impulsion()


# Applaying impulse over the crystal
func impulsion():
	apply_impulse(Vector2.ZERO, Vector2(rand_range(-60, 60), -150))
	gravity_scale = rand_range(1.5, 2.0)
	

# Deleting the crystal from the scene
func destruct_crystal(type):
	if type == 1:
		Game.sumPoints(1)
		queue_free()
	else:
		queue_free()


# Calling the desctruct_crystal function, when the player is entering the crystal area
func _on_crystal_area_body_entered(body):
	Sounds.play_crystal()
	destruct_crystal(1)

# Calling the desctuct_crystal function, when player's camera is out of range
func _on_notifier2d_screen_exited():
	destruct_crystal(0)
	
	
