extends Particles2D

# Variables
var time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	emitting = true
	$stars.emitting = true
	pass 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	if time > 1.5:
		queue_free()
