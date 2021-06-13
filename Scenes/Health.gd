extends Label

func _process(delta):
	set_text("Health: " + str(Main.health))
