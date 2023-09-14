extends ColorRect

# Variables
var reset = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$showText.play("animationPressKey")

# Resetting the game 
func _input(event):
	if event is InputEventKey and reset:
		if event.pressed:
			Game.resetGame()
			Transition.play_transition("res://scene/level1.tscn")

func _on_showText_animation_finished(anim_name):
	reset = true
