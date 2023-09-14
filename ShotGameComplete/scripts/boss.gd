extends KinematicBody2D

# Constants
const GRAVITY = 4000
const PRELOAD_LASER = preload("res://scene/laser_boss.tscn")

# Variables
var velocity = Vector2.ZERO
var speed = 300

# Boss behavior 
var state = 1
var behavior = 0
var time_behavior = 0
var cycle = 0
var direction = -1
var max_shoot = 6
var result = 0

# Boss start
var start_behavior = false

# Laser behavior
var laser_falling = false

# Boss life
var hp = 30
var hit = false
var die = false
var boss_levelup = false
var limit_hp = hp/2
var boss_value = 10

# controller for visibility to the shader feature
var value_alpha = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	if !die:
		result = position.x - get_parent().get_child(3).position.x
	
	# Applying gravity to the master
	velocity.y = GRAVITY * delta
	
	# Boss levelup 
	if hp <= limit_hp and !boss_levelup:
		state = 2
		$animation_boss.playback_speed += 2
		Sounds.play_boss_fury()
		speed = 600
		boss_levelup = true
	
	# Boss state and behavior
	if start_behavior and !die:
		
		if !hit:
			if state == 1:
				# The boss will be more easy
				
				if behavior == 0:
					# Action idle
					idle(delta)
				elif behavior == 1:
					# Action walk
					walk()
				elif behavior == 2:
					# Action shooter_preparete
					if result > 0 and scale.x == 1:
						top_preparete()
					elif result < 0 and scale.x == -1:
						top_preparete()
					else:
						shooter_preparete()
				elif behavior == 3:
					# Action top_preparete
					top_preparete()
			else:
				# The boss will be more hard
				
				if behavior == 0:
					# Action idle
					idle(delta)
				elif behavior == 1:
					# Action walk
					walk()
				elif behavior == 2:
					# Action shooter_preparete
					if result > 0 and scale.x == 1:
						top_preparete()
					elif result < 0 and scale.x == -1:
						top_preparete()
					else:
						shooter_preparete()
				elif behavior == 3:
					# Action top_preparete
					top_preparete()
		else:
			behavior = int(rand_range(1, 3))
		
	# While doesn't have any border the master will keep walking
	velocity = move_and_slide(velocity, Vector2.UP, true)
	
	# Flashing the boss image, when it was hitted
	flash(delta)
	
	# Treating the laser falling behavior
	if laser_falling:
		shoot(-180, 2)
		laser_falling = false

# Idle function
func idle(period):
	$animation_boss.play("idle")
	velocity.x = 0
	time_behavior += period
	
	# Changing the behavior when the time is equal to 2
	if time_behavior > 1:
		time_behavior = 0
		behavior = int(rand_range(0, 4))

# Walk function
func walk():
	$animation_boss.play("walk")
	# Walking behavior
	if cycle < 1:
		# Walking left
		if direction == -1:
			velocity.x = -speed
			if position.x <= $"../left".position.x:
				direction = 1
				cycle += 1
				flip()
		# Walking right
		if direction == 1:
			velocity.x = speed
			if position.x >= $"../right".position.x:
				direction = -1
				cycle += 1
				flip()
	else:
		behavior = 0
		cycle = 0
		

# Changing the sprite image direction
func flip():
	scale.x *= -1
	

# Calling the animation shooter_preparete 
func shooter_preparete():
	$animation_boss.play("shooter_preparete")

# Calling the animation shooter
func shooter():
	$animation_boss.play("shooter")
	$pos.position = Vector2(150, 15)
	$pos.rotation_degrees = 0
	shoot(0, 1)
	
# Calling the animation top_preparete
func top_preparete():
	$animation_boss.play("top_preparete")

# Calling the animation top_shooter
func top_shooter():
	$animation_boss.play("top_shooter")
	$pos.position = Vector2(-68, -208)
	$pos.rotation_degrees = -90
	shoot(0, 1)
	laser_falling = true
	
	
# Calling the animation return_shooter_idle
func return_shooter_idle():
	$animation_boss.play("return_shooter_idle")
	
# Calling the animation return_top_shooter
func return_top_shooter():
	$animation_boss.play("return_top_shooter")

# Calling the animation die
func die():
	$animation_boss.play("die")
	start_behavior = false
	die = true
	Game.score += boss_value
	Game.sumPoints(Game.score)
	velocity.x = 0

# When animation has finished, so will change to another
func _on_animation_boss_animation_finished(anim_name):
	match anim_name:
		"shooter_preparete":
			behavior = 4
			shooter()
		"shooter":
			if state == 1:
				return_shooter_idle()
			else:
				Sounds.play_boss_fury()
				if max_shoot >= 0:
					shooter()
					max_shoot -= 1
				else:
					max_shoot = 6
					return_shooter_idle()
		"top_preparete":
			behavior = 5
			top_shooter()
		"top_shooter":
			if state == 1:
				return_top_shooter()
			else:
				Sounds.play_boss_fury()
				if max_shoot >= 0:
					top_shooter()
					max_shoot -= 1
				else:
					max_shoot = 6
					return_top_shooter()
		"return_shooter_idle":
			behavior = 0
		"return_top_shooter":
			behavior = 0
		"die":
			get_parent().level_clear = true

# Boss hitted 
func hitted():
	$animation_boss.play("hit")
	velocity.x = 0
	hit = true
	hp -= 1
	if hp <= 0:
		die()
	else:
		value_alpha = 1


# The boss will move only if the player camera reaches him
func _on_notifier_screen_entered():
	if hp > 0:
		start_behavior = true


# Boss's head area and laser interaction
func _on_head_area_area_entered(area):
	if !die:
		Sounds.play_impact()
		if hp > 0:
			hitted()
		else:
			die()
		if area.name == "feet_area":
			# Player jumping over the boss's head
			var player = area.get_parent()
			var force = 1200
			if player.get_node("player_img").scale.x == -1:
				player.jump2_left(force)
			else:
				player.jump2(force)

# Flashing the boss image, when it was hitted
func flash(delta):
	$boss_img.material.set_shader_param('alpha', value_alpha)
	if hit:
		value_alpha -= delta*3
	if value_alpha <= 0:
		hit = false


# Implementing the boss and player interaction
func _on_boss_body_area_body_entered(body):
	if !Game.gameover and !die:
		Sounds.play_impact()
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

# Shoot function
func shoot(rotation_laser, type):
	# Instantiating the laser beam on the scene, and adding the beam to it
	Sounds.play_shoot()
	var l = PRELOAD_LASER.instance()
	l.transform = $pos.global_transform
	l.type = type
	
	get_parent().add_child(l)
	l.rotation_laser = rotation_laser
	l.speed = 1000
	Sounds.stop_shoot()
	
	# Laser falling over the player 
	if type == 2:
		l.position.y = $"../player".position.y - 1000
		l.position.x = $"../player".position.x + rand_range(-250, 250)
	
