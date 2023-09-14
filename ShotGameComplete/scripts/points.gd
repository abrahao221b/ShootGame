extends Label

# Variables
var velocity = 50
var label_text = 10
var time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	text = str(label_text)
	pass 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity += 5
	rect_position.y -= delta * velocity
	
	# Deleting the text
	time += delta
	if time > 1:
		queue_free()
