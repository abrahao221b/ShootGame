extends CanvasLayer


# Variables
var scene = "res://scene/gameover.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass 


func play_transition(name_scene):
	scene = name_scene
	$animationTransition.play("fade")
	
func change_scene():
	get_tree().change_scene(scene)
