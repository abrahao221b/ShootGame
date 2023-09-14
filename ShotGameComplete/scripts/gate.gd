extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$door_animation.playback_speed = 1.5

# Door and player interaction, the player is entering the door's area 
func _on_area_door_body_entered(body):
	if !get_parent().door_close or get_parent().level_clear: 
		Sounds.play_door_openning()
		$door_animation.play("open")
		Sounds.stop_door()

# Door and player interaction, now the player is leaving the door's area
func _on_area_door_body_exited(body):
	if !get_parent().door_close or get_parent().level_clear:
		Sounds.play_door_openning()
		$door_animation.play("close")
		Sounds.stop_door()
	if !get_parent().level_clear:
		get_parent().door_close = true
