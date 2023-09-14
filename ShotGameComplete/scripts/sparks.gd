extends Particles2D


# Variables
var time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	# Sparks node emission
	emitting = true
	# Points node emission
	$points.emitting = true
	$points.speed_scale = 2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	if time > 1:
		queue_free()
