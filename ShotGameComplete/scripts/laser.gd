extends Area2D

# Constants
const PRE_DAMAGE = preload("res://scene/label_points.tscn")
const PRE_SPARKS = preload("res://scene/sparks.tscn")

# Variables
var speed = 2000
var rotation_laser = 0
var damage_points = 2

# Laser type, there will be two laser types
# Laser type 1: the laser will move forward
# Laser type 2: the laser will move upward and downward 
var type = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if type == 1:
		# Setting the laser beam speed 
		position += transform.x * speed * delta
		$laser_img.rotation_degrees = rotation_laser
	else:
		position.y += speed * delta
		$laser_img.rotation_degrees = rotation_laser


# Function that treats the interaction laser and enemy
func _on_laser_area_entered(area):
	Sounds.play_impact()
	if area.name == "enemy_area":
		var enemy = area.get_parent()
		# Causing damage to the enemy
		enemy.damage(damage_points)
		
		# Pouching the enemy away when it is damaged by the laser beam
		if position.x < enemy.position.x:
			enemy.position.x += 8
		else:
			enemy.position.x -= 8
		# Showing the damage
		if enemy.hp >= 0:
			show_damage(true)
		# Deleting the laser when it touches the enemy
		queue_free()
	else:
		# Treating other contacts of laser interaction
		if !area.get_parent().die:
			show_damage(false)
			# Deleting the laser when it touches the enemy
			queue_free()
	
	
# Deleting the laser when it exits the scene
func _on_notifier_screen_exited():
	queue_free()

# Showing the damage caused by the laser beam
func show_damage(show_sparks):
	if show_sparks:
		# Showing the text of the damage
		var damage_label = PRE_DAMAGE.instance()
		damage_label.label_text = damage_points
		damage_label.rect_global_position = global_position
		get_parent().add_child(damage_label)
	# Creating the sparks
	var sparks = PRE_SPARKS.instance()
	sparks.global_position = global_position
	get_parent().add_child(sparks)
	
	

# Boss's laser interaction with the player
func _on_laser_boss_body_entered(body):
	if !body.on_hit:
		Sounds.play_impact()
		# Deleting the laser
		queue_free()
		# Creating sparks when the laser touches the player
		show_damage(false)
		if Game.lifes > 0:
			body.player_hitted()
			if body.position.x < position.x:
				body.push_back(1)
			else:
				body.push_back(-1)
		
			# Changing the player death's sprite position 
			if Game.lifes < 1:
				if body.position.x < position.x:
					body.get_node("player_img").scale.x = -1
				else:
					body.get_node("player_img").scale.x = 1

