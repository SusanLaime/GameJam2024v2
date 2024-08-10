extends Node

var hurt = preload("res://assets/audio/hurt.wav")
var jump = preload("res://assets/audio/jump.wav")
var salar = preload("res://assets/audio/1. Salar.MP3")
func play_sfx(sfx_name: String):
	var stream = null
	if sfx_name == "hurt":
		stream = hurt
	elif sfx_name == "jump":
		stream = jump
	elif sfx_name == "salar":
		stream = salar
	else:
		print("Invalid sfx name")
		return
	
	var asp = AudioStreamPlayer.new()
	asp.stream = stream
	asp.name = "SFX"
	
	add_child(asp)
	
	asp.play()
	
	await asp.finished
	asp.queue_free()
	
func stop_sfx():
	var asp = AudioStreamPlayer.new()
	var stream = null
	asp.stream = stream
	asp.name = "SFX"
	add_child(asp)
	asp.stop()

