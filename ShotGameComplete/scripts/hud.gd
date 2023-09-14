extends Node


# Constants
const PRE_HEARTS_BACKGROUND = preload("res://scene/heart_background.tscn")
const PRE_HEARTS_FRONT = preload("res://scene/heart_front.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	# Printing the player's hearts
	for i in Game.back_hearts:
		var icon_background = PRE_HEARTS_BACKGROUND.instance()
		var icon_front = PRE_HEARTS_FRONT.instance()
		$hearts_background.add_child(icon_background)
		$hearts_front.add_child(icon_front)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$life.text = "∲∯x" + str(Game.lifes)
	$score.text = str(Game.score)
	show_hearts_front()

# Function that verifies the quantity of hearts that should be shown
func show_hearts_front():
	for i in $hearts_front.get_child_count():
		$hearts_front.get_child(i).visible = Game.hearts > i
		
