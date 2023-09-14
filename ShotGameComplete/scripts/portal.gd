extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass 

# player and portal interaction
func _on_portal_body_entered(body):
	Transition.play_transition("res://scene/level2.tscn")
