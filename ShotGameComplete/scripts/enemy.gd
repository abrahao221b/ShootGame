extends KinematicBody2D

# Constants
const GRAVITY = 4000
const PRE_EXPLOSION = preload("res://scene/explosion.tscn")
const PRE_CRYSTAL = preload("res://scene/crystal.tscn")

# Variables
var velocity = Vector2.ZERO
var velocity_max = 200
export(int, "left", "right") var direction = 0
export(int, "walk", "idle") var type = 0

# Enemy life
var hp = 15

# Hit animation
var animation_hit = false

# Called when the node enters the scene tree for the first time
func _ready():
	if direction == 0:
		$enemy_img.scale.x = -1
		$enemy_ray_cast.position.x *= -1
		$enemy_ray_cast_front.position.x *= -1
		$enemy_ray_cast_front.cast_to.x *= -1
	else:
		$enemy_img.scale.x = 1
		$enemy_ray_cast.position.x = 70
		$enemy_ray_cast_front.position.x = 70
		$enemy_ray_cast_front.cast_to = 50
		
	# Calling enemy's behavior animation
	if type == 1:
		$animation_enemy.play("idle")
	else:
		$animation_enemy.play("walk")


# Called every frame. 'delta' is the elapsed time since the previous frame
func _process(delta):	
	# Applying gravity
	velocity.y += GRAVITY * delta
	
	# Only if the enemy has not on the idle animation
	if type != 1:
		# Enemy movement
		if !animation_hit:
			if $enemy_ray_cast.is_colliding() and !$enemy_ray_cast_front.is_colliding():
				if direction == 0: 		# Left
					velocity_max = -200
				else: 					# Right
					velocity_max = 200
			else:
				$enemy_ray_cast.position.x *= -1
				$enemy_ray_cast_front.position.x *= -1
				$enemy_ray_cast_front.cast_to.x *= -1
				if direction == 0:
					direction = 1
					$enemy_img.scale.x *= -1
				else:
					direction = 0
					$enemy_img.scale.x *= -1
			velocity.x = velocity_max
		
		velocity = move_and_slide(velocity, Vector2.UP, true)

# Function that deals the enemy damage
func damage(value):
	hp -= value
	if hp < 1:
		var player_position = $"../../player".position.x
		if player_position < position.x:
			$enemy_img.scale.x = -1
			velocity.x = 350
		else:
			$enemy_img.scale.x = 1
			velocity.x = -350
		animation_hit = true
		$shadow.visible = false
		$animation_enemy.play("hit")

# Finishing animation
func _on_animation_enemy_animation_finished(anim_name):
	if anim_name == "hit":
		Sounds.play_explosion()
		var explosion = PRE_EXPLOSION.instance()
		if $enemy_img.scale.x == -1:
			explosion.global_position = $enemy_img.global_position + Vector2(50, 50)
		else:
			explosion.global_position = $enemy_img.global_position + Vector2(-50, 50)
		get_parent().add_child(explosion)
		Sounds.stop_explosion()
		crytals_instantiation()
		queue_free()

# Implementing the enemy and player interaction
func _on_enemy_area_body_entered(body):
	Sounds.play_impact()
	if !body.on_hit and !Game.gameover:
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

# Crystals instantiation
func crytals_instantiation():
	randomize()
	var quantity_crystal = int(rand_range(1, 4))
	for i in quantity_crystal:
		var c = PRE_CRYSTAL.instance()
		c.global_position = global_position
		get_parent().get_parent().add_child(c)
