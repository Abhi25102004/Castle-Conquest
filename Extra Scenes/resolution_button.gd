extends Button

func _ready() -> void:
	self.pressed.connect(func():
		match self.text:
			"Windowed":
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			"Full Screen":
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		)
