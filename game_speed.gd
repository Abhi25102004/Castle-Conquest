extends Button

var Bus_index : int

@export var Normal : CompressedTexture2D
@export var Incresed : CompressedTexture2D

func _ready() -> void:
	if Global.Game_Speed_Increased:
		self.icon = Incresed
	else:
		self.icon = Normal
	
	self.pressed.connect(func():
		if Global.Game_Speed_Increased:
			self.icon = Normal
			Global.Game_Speed_Increased = false
		else:
			self.icon = Incresed
			Global.Game_Speed_Increased = true
		)
