extends Node2D

@export var next_level: PackedScene = null
@export var is_final_level: bool = false
@export var is_first_level: bool = true
@export var level_number: int = 1
@onready var start = $Start
@onready var exit = $Exit
@onready var death_zone = $Deathzone

@onready var hud = $UILayer/HUD
@onready var ui_layer = $UILayer

var newObject = preload("res://scenes/spawn_object.tscn")
var player = null
var second_player = preload("res://scenes/second_player.tscn")
var third_player = preload("res://scenes/third_player.tscn")
var save_position_player

@export var level_time = 5

var timer_node = null
var time_left

var win = false
var player_paths = {
	1: "res://scenes/player.tscn",
	2: "res://scenes/second_player.tscn",
	3: "res://scenes/third_player.tscn"
}




func _ready():
	#spawn_player_for_level(level_number)
	#print(level_time)
	AudioPlayer.play_sfx("level_one")

	player = get_tree().get_first_node_in_group("player")
	#if player!=null:
	#	player.global_position = start.get_spawn_pos()
	var traps = get_tree().get_nodes_in_group("traps")
	for trap in traps:
		#trap.connect("touched_player", _on_trap_touched_player)
		trap.touched_player.connect(_on_trap_touched_player)
	
	exit.body_entered.connect(_on_exit_body_entered)
	death_zone.body_entered.connect(_on_deathzone_body_entered)
	
	time_left = level_time
	hud.set_time_label(time_left)


	
	timer_node = Timer.new()
	timer_node.name = "Level Timer"
	timer_node.wait_time = 1
	timer_node.timeout.connect(_on_level_timer_timeout)
	add_child(timer_node)
	timer_node.start()

func _on_level_timer_timeout():
	if win == false:
		time_left -= 1
		hud.set_time_label(time_left)
		if time_left == 0:
			save_position_player = player.position
		if time_left < 0:
			AudioPlayer.play_sfx("hurt")
			reset_player()
			time_left = level_time
			hud.set_time_label(time_left)
			leave_new_object()
			
func spawn_player_for_level(level):
	if player_paths.has(level):
		var player_scene = load(player_paths[level])
		var player = player_scene.instance()
		add_child(player)
		player.position = Vector2(100, 100) # Set initial position
	else:
		print("No player character found for level ", level)

func _process(delta):
	save_position_player = player.position
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("force_loop"):
		time_left = level_time
		leave_new_object()
		reset_player()
		
	elif Input.is_action_just_pressed("reset"):
		
		get_tree().reload_current_scene()

func _on_deathzone_body_entered(body):
	AudioPlayer.play_sfx("hurt")
	reset_player()

func _on_trap_touched_player():
	AudioPlayer.play_sfx("hurt")
	reset_player()

func reset_player():
	player.velocity = Vector2.ZERO
	player.global_position = start.get_spawn_pos()

func _on_exit_body_entered(body):
	if body is Player:
		if is_final_level || (next_level != null):
			exit.animate()
			player.active = false
			win = true
			await get_tree().create_timer(1.5).timeout
			if is_final_level:
				AudioPlayer.stop_sfx()
				AudioPlayer.play_sfx("final")
				ui_layer.show_win_screen(true)
			else:
				get_tree().change_scene_to_packed(next_level)
				
func leave_new_object():
	var object = newObject.instantiate()
	if player:
		object.position = save_position_player
		add_child(object)
	AudioPlayer.play_sfx("petrified")
