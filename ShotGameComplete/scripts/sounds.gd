extends Node2D

# Playing the crystal sound, when player takes it 
func play_crystal():
	$crystal.play()

# Sound impact
func play_impact():
	$impact.play()

# Running sound
func play_running():
	$running.play()

# Stopping the running sound
func stop_running():
	$running.stop()

# Player jump voice
func play_jump_voice():
	$jump_voice.play()

# Boss fury sound 
func play_boss_fury_pass():
	$boss_fury_pass.play()

# Boss fury voice
func play_boss_fury():
	$boss_fury.play()

# Start game sound
func play_start_game():
	$start_game.play()

# Background sound
func play_background_sound():
	$background_sound.play()

# Stopping background sound
func stop_background_sound():
	$background_sound.stop() 

# Player fall sound 
func play_fall():
	$fall.play()

# You lose sound
func play_you_lose():
	$you_lose.play()

# Door opening sound
func play_door_openning():
	$door_openning.play()

# Stopping door opening sound
func stop_door():
	$door_openning.stop()

# Explosion sound
func play_explosion():
	$explosion.play()

# Stopping the explosion sound
func stop_explosion():
	$explosion.stop()

# Weapon shoot sound 
func play_shoot():
	$laser_shoot.play()

# Stopping the weapon shoot sound
func stop_shoot():
	$laser_shoot.stop()
