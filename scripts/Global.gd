extends Node

var save_path = "user://score.save"
var highscore

func save_score():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(highscore)

func load_score():
	if FileAccess.file_exists(save_path):
		print("file found")
		var file = FileAccess.open(save_path, FileAccess.READ)
		highscore = file.get_var()
	else:
		print("file not found")
		highscore = 0