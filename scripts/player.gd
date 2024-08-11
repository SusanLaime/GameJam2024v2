extends CharacterBody2D
class_name Player

@export var gravity = 400
@export var jump_force = 200
@export var speed = 250

@onready var animated_sprite = $AnimatedSprite2D
var level = 1 
var active = true

func _physics_process(delta):
	if is_on_floor()==false:
		velocity.y += gravity * delta
		if velocity.y > 500:
			velocity.y = 500
	
	var direction = 0
	if active==true:
		if Input.is_action_just_pressed("jump"): #&& is_on_floor():
			jump(jump_force)
		
		direction = Input.get_axis("move_left", "move_right")
	if direction != 0:
		animated_sprite.flip_h = (direction == -1)
	
	velocity.x = direction * speed
	move_and_slide()
	if level == 1:
		
		update_animations(direction, sprite_level1)
	elif level == 2:
		update_animations(direction, sprite_level2)
	else:
		update_animations(direction, sprite_level3)

func jump(force):
	AudioPlayer.play_sfx("jump")
	if is_on_floor() == true:
		velocity.y = -force

func update_animations(direction, animated_sprite):
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		if velocity.y < 0:
			animated_sprite.play("jump")
		else:
			animated_sprite.play("fall")
			
			
var sprite_level1: AnimatedSprite2D
var sprite_level2: AnimatedSprite2D
var sprite_level3: AnimatedSprite2D

func _ready():
	sprite_level1 = $AnimatedSprite2D
	sprite_level2 = $AnimatedSprite2D2
	sprite_level3 = $AnimatedSprite2D3
	sprite_level1.visible = false
	sprite_level2.visible = false
	sprite_level3.visible = false
	set_sprite_for_level(get_current_level())
	var level_name = get_tree().get_current_scene().get_name()
	
func get_current_level() -> int:
	var level_name = get_tree().get_current_scene().get_name()
	if level_name == "Level":
		level = 1
		return 1
	elif level_name == "Level_2":
		level = 2
		return 2
	else: 
		level = 3
		return 3
		
func set_sprite_for_level(level:int):
	match level:
		1:
			sprite_level1.visible = true
		2:
			sprite_level2.visible = true
		3:
			sprite_level3.visible = true
	sprite_level1.visible = (level == 1)
	sprite_level2.visible = (level == 2) 
	

			

