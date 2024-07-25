class_name Paddle
extends CharacterBody2D

var game_lost
var speed
var screen_size

func _ready():
	screen_size = get_window().size
	speed = screen_size.x/1.15
	game_lost = false

func _process(delta):
	if game_lost == false:
		if Input.is_action_pressed('Left') and position.x >= 64:
			velocity.x = -speed
			position.x += velocity.x * delta
		if Input.is_action_pressed('Right') and position.x <= screen_size.x - 64:
			velocity.x = speed
			position.x += velocity.x * delta

