class_name Ball
extends CharacterBody2D

var speed
var screen_size
var game_started
var direction = Vector2(0, -1)
signal score

func _ready():
	screen_size = get_window().size
	speed = screen_size.y /1.5
	game_started = false

func _physics_process(delta):
	if game_started == true:
		velocity = direction * speed
		var movement = move_and_collide(velocity * delta)
		if movement:
			var normal = movement.get_normal()
			var collider = movement.get_collider()
			if collider is Paddle:
				$bump.play()
				direction = collider.position.direction_to(self.position)
			else:
				direction = direction.bounce(normal)
				if collider is Brick:
					$hit.play()
					speed += speed/100
					collider.queue_free()
					score.emit()
				else:
					$bump.play()
	else:
		velocity = Vector2.ZERO
		

