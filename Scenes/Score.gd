extends Label

func _process(delta):
	set_text("Score: " + str(Main.score))
