extends KinematicBody2D

# Constants
const PRELOAD_LASER = preload("res://scene/laser.tscn")
const GRAVITY = 4000


# Variables
var velocity = Vector2.ZERO
var velocity_max = 350

# Action type with the player's weapon
var action_type = 1

# Character jump variable
var count_jump = 2
var jump_force = 1200
var is_jump = false

# Camera properties
var offset_cam = 0
var offset_max = 250

# Player landing
var was_falling = false

# Hitting on the player
var on_hit = false


# Called when the node enters the scene tree for the first time
func _ready():
	Sounds.play_start_game()
	Sounds.play_background_sound()
	$camera.limit_left = $"../limit_left".position.x
	$camera.limit_right = $"../limit_right".position.x

# Called every frame. 'delta' is the elapsed time since the previous frame
func _process(delta):
	# Reloading scene if the player falls in hole
	if position.y >= 1436:
		Sounds.play_fall()
		get_tree().reload_current_scene()
		Game.resetGame()
	
	
	# Applying gravity
	velocity.y += GRAVITY * delta
	
	# Character direction
	var direction = Input.get_axis("left", "right")
	
	# Character velocity 
	if Game.lifes > 0:
		if direction != 0:
			velocity.x = lerp(velocity.x, direction * velocity_max, 0.3)
			if $player_img.scale.x == 1:
				offset_cam = lerp(offset_cam, offset_max, 0.03)
			else:
				offset_cam = lerp(offset_cam, -offset_max, 0.03)
		else:
			if is_on_floor():
				velocity.x = lerp(velocity.x, 0, 0.15)
			else:
				velocity.x = lerp(velocity.x, 0, 0.001)
	else:
		velocity.x = 0
		velocity.y = 0
	
	# Showing little bit forward the view to the player
	$camera.offset.x = offset_cam
	
	# Character points the gun up
	var top = Input.is_action_pressed("top")
	
	if Game.lifes > 0:
		if is_on_floor():
			# Changing character's sprite direction 
			if direction > 0:
				$player_img.scale.x = 1
			if direction < 0:
				$player_img.scale.x = -1
				
			# Character animation
			if !on_hit:
				if was_falling:
					$animation_player.play("jump3")
				else:
					if direction != 0:
						if action_type == 1:
							$animation_player.play("running")
						if action_type == 2:
							$animation_player.play("diagonal_running")
						if action_type == 3:
							$animation_player.play("top_running")
					else:
						if !top:
							Sounds.stop_running()
							$animation_player.play("idle")
						else:
							Sounds.stop_running()
							$animation_player.play("top_idle")
			else:
				$animation_player.play("hit")
				$player_img.rotation_degrees = 0
		else:
			was_falling = true
			if on_hit:
				$animation_player.play("hit")
				$player_img.rotation_degrees = 0
		
		# Defining the action_type value
		if direction != 0 and !top:
			# The character is pointing the gun for the left or the right
			action_type = 1
		elif direction != 0 and top and action_type != 3:
			# The character is pointing the gun for the diagonal
			action_type = 2
		elif top:
			# The character is pointing the gun up
			action_type = 3
		else:
			# The character is pointing again the gun for the left or the right
			action_type = 1
		
		
		# Resetting count_jump variable
		if is_on_floor():
			is_jump = false
			$shadow.visible = true
			count_jump = 2 	
			$player_img.rotation_degrees = 0
		else:
			$shadow.visible = false
		
		# Character jump
		if Input.is_action_just_pressed("jump") and count_jump > 0 and !on_hit:
			count_jump -= 1
			if count_jump < 1:
				if $player_img.scale.x == 1:
					jump2(jump_force)
				if $player_img.scale.x == -1:
					jump2_left(jump_force)
			else:
				jump(jump_force)
	else:
		if !Game.gameover:
			$animation_player.play("die")
	
	# Character movement
	velocity = move_and_slide(velocity, Vector2.UP, true)
	
	# Checking the weapon_hole's position
	var rotation_laser = 0
	if $player_img.scale.x == 1:
		if action_type == 1: # Right
			$weapon_hole.position = Vector2(96, 70)
			$weapon_hole.rotation_degrees = 0
		elif action_type == 2:
			$weapon_hole.position = Vector2(85, 13)
			$weapon_hole.rotation_degrees = -25
			rotation_laser = -10
		elif action_type == 3:
			$weapon_hole.position = Vector2(15, -41)
			$weapon_hole.rotation_degrees = -90
	else: # Left
		if action_type == 1: 
			$weapon_hole.position = Vector2(-96, 70)
			$weapon_hole.rotation_degrees = 180
		elif action_type == 2:
			$weapon_hole.position = Vector2(-85, 13)
			$weapon_hole.rotation_degrees = -154
			rotation_laser = 10
		elif action_type == 3:
			$weapon_hole.position = Vector2(-15, -41)
			$weapon_hole.rotation_degrees = -90
	
	# Shoot action
	if Input.is_action_just_pressed("shoot") and !is_jump and Game.lifes > 0:
		shoot(rotation_laser)
	else:
		$weapon_hole/laser_light.visible = false
	
# Jump function
func jump(force):
	Sounds.play_jump_voice()
	Sounds.stop_running()
	is_jump = true
	velocity.y = -force
	$animation_player.play("jump1")

# Jump2 function
func jump2(force):
	Sounds.play_jump_voice()
	Sounds.stop_running()
	velocity.y = -force
	$animation_player.play("jump2")
	
# Jump2_left function 
func jump2_left(force):
	Sounds.play_jump_voice()
	Sounds.stop_running()
	velocity.y = -force
	$animation_player.play("jump2_left")
	
# Shoot function
func shoot(rotation_laser):
	Sounds.play_shoot()
	# Instantiating the laser beam on the scene, and adding the beam to it
	var l = PRELOAD_LASER.instance()
	l.transform = $weapon_hole.global_transform
	get_parent().add_child(l)
	l.rotation_laser = rotation_laser
	$weapon_hole/laser_light.visible = true
	Sounds.stop_shoot()

# Player finishing the landing animation
func _on_animation_player_animation_finished(anim_name):
	match anim_name:
		"jump3":
			was_falling = false
		"hit":
			on_hit = false
		"die":
			if !Game.gameover:
				Sounds.stop_background_sound()
				Sounds.play_you_lose()
			Game.gameover = true
			Transition.play_transition("res://scene/gameover.tscn")
			for i in $"../HUD".get_child_count():
				$"../HUD".get_child(i).visible = false

# Will be called whether the player was hitted
func player_hitted():
	Game.hearts -= 1
	on_hit = true
	if Game.hearts < 1:
		Game.lifes -= 1
		if Game.lifes > 0:
			Game.hearts = 5
	

# Applying force when the player was hitted
func push_back(value):
	if value == 1:
		velocity.x = -1000
	else:
		velocity.x = 1000
	velocity.y = -500

# Playing the running sound
func play_running_sound():
	Sounds.play_running()
	
# Stopping the running sound
func stop_running_sound():
	Sounds.stop_running()
