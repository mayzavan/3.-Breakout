extends Node

@export var brick_scene : PackedScene
@export var paddle_scene : PackedScene
@export var ball_scene : PackedScene
@export var heart_scene : PackedScene

var brick_amount : Array = [0,0]
var brick_displacement : Array = [71,32]
var paddle
var ball
var screen_size
var game_started
var lifes
var score
var game_lost
var highscore
 
func _ready():
	Global.load_score()
	highscore = Global.highscore
	$gamelost/Label3.text = ('Highscore: ' + str(highscore))
	game_lost = false
	score = 0
	$CanvasLayer/Label.text = str(score)
	$gamelost.hide()
	lifes = 3
	game_started = false
	screen_size = get_window().size
	$Right.scale.x = screen_size.x
	$Right.position.x = screen_size.x
	$Left.scale.x = screen_size.x
	$Left.position.x = 5
	$worldboundaries/top.shape.b.x = screen_size.x
	$worldboundaries/right.shape.a.x = screen_size.x
	$worldboundaries/right.shape.b.x = screen_size.x
	$worldboundaries/right.shape.b.y = screen_size.y
	$worldboundaries/left.shape.b.y = screen_size.y
	$diearea/CollisionShape2D.position.y = screen_size.y + 100
	$diearea/CollisionShape2D.scale.x = screen_size.x*2
	$diearea/CollisionShape2D.scale.y = 2
	$CanvasLayer/Label.position = Vector2(screen_size.x - ($CanvasLayer/Label.size.x + 15), 10)
	$gamelost/Label.position = Vector2((screen_size.x - $gamelost/Label.size.x)/2, (screen_size.y - $gamelost/Label.size.y)/2)
	$gamelost/Label2.position = Vector2((screen_size.x - $gamelost/Label2.size.x)/2, (screen_size.y - $gamelost/Label2.size.y)/2 + 100)
	$gamelost/Label3.position = Vector2(10,10)
	
	brick_amount[0] = int((screen_size.x - 32)/74)
	brick_amount[1] = int((screen_size.y/2 - 10)/38)
	for y in brick_amount[1]:
		for x in brick_amount[0]:
			var brick = brick_scene.instantiate()
			brick.position.x = brick_displacement[0] * (x + 1)
			brick.position.y = brick_displacement[1] * (y + 3)
			add_child(brick)
			
	paddle = paddle_scene.instantiate()
	paddle.position = Vector2(screen_size.x/2 , screen_size.y*9/10)
	add_child(paddle)
	ball = $ball
	ball.position = Vector2(paddle.position.x, paddle.position.y - 30)
	show_hearts()

func _process(delta):
	if game_lost == false:
		if Input.is_action_just_pressed('Start'):
			start_game()
		if game_started == false:
			ball.position.x = paddle.position.x
	if game_lost == true and Input.is_action_just_pressed('Start'):
		get_tree().reload_current_scene()

func start_game():
	$ball.game_started = true
	game_started = true

func _on_diearea_body_entered(body):
	print(body)
	if body is Ball:
		lifes -=1
		game_started = false
		ball.game_started = false
		paddle.position = Vector2(screen_size.x/2 , screen_size.y*9/10)
		ball.position = Vector2(paddle.position.x, paddle.position.y - 30)
		show_hearts()
	
func show_hearts():
	get_tree().call_group("hearts" , "queue_free")
	for i in lifes:
		var heart = heart_scene.instantiate()
		heart.position = Vector2(36 + i*74 , 36)
		add_child(heart)
	if lifes <= 0:
		game_lost = true
		paddle.game_lost = true
		$gamelost.show()

func scoring():
	score += 100
	$CanvasLayer/Label.text = str(score)
	if score > highscore:
		Global.highscore = score
		Global.save_score()
		highscore = score
	$gamelost/Label3.text = ('Highscore: ' + str(highscore))
