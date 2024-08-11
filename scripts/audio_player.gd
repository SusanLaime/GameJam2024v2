extends Node

var hurt = preload("res://assets/audio/hurt.wav")
var jump = preload("res://assets/audio/drive-download-20240811T150329Z-001/salto 1.mp3")
var level_one = preload("res://assets/audio/drive-download-20240811T150329Z-001/nivel 1.mp3")
var final = preload("res://assets/audio/drive-download-20240811T150329Z-001/final solitario.mp3")
var level_two = preload("res://assets/audio/drive-download-20240811T150329Z-001/nivel 1.mp3")
var level_three = preload("res://assets/audio/drive-download-20240811T150329Z-001/nivel 3.mp3")
var petrified = preload("res://assets/audio/drive-download-20240811T150329Z-001/petrificacion.mp3")
func play_sfx(sfx_name: String):
	var stream = null
	if sfx_name == "hurt":
		stream = hurt
	elif sfx_name == "jump":
		stream = jump
	elif sfx_name == "level_one":
		stream = level_one
	elif sfx_name == "level_two":
		stream = level_two
	elif sfx_name == "level_three":
		stream = level_three
	elif sfx_name == "petrified":
		stream = petrified
	elif sfx_name == "final":
		stream = final
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

