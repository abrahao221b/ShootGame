extends Node


# Variables

# Player features 
var lifes = 1
var hearts = 5
var gameover = false
var back_hearts = 5

# Game score
var score = 0
var levelup = 10


# Called when the node enters the scene tree for the first time.
func _ready():
	pass 

# Implementing the game points behavior
func sumPoints(value):
	score += value
	if score >= levelup:
		lifeGain()
		levelup += 10
		return true
	return false

# Reseting the game score
func resetGame():
	lifes = 1
	hearts = 5
	score = 0
	levelup = 10
	gameover = false
	
# Gain life 
func lifeGain():
	lifes += 1

# Loses life
func losesLife():
	lifes -= 1

# Loses heart
func losesHearts():
	hearts -= 1
	
# Reseting the score
func resetScore():
	score = 0
