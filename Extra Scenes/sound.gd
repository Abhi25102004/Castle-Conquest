extends Button

var Bus_index : int

@export var Mute_icon : CompressedTexture2D
@export var Unmute_icon : CompressedTexture2D

func _ready() -> void:
	Bus_index = AudioServer.get_bus_index("Master")
	if db_to_linear(AudioServer.get_bus_volume_db(Bus_index)) > 0 :
		self.icon = Unmute_icon
		self.vertical_icon_alignment = VERTICAL_ALIGNMENT_BOTTOM
	else:
		self.icon = Mute_icon
		self.vertical_icon_alignment = VERTICAL_ALIGNMENT_CENTER
	
	self.pressed.connect(func():
		if db_to_linear(AudioServer.get_bus_volume_db(Bus_index)) > 0 :
			AudioServer.set_bus_volume_db(Bus_index,linear_to_db(0))
			self.icon = Mute_icon
			self.vertical_icon_alignment = VERTICAL_ALIGNMENT_CENTER
		else:
			AudioServer.set_bus_volume_db(Bus_index,linear_to_db(0.5))
			self.icon = Unmute_icon
			self.vertical_icon_alignment = VERTICAL_ALIGNMENT_BOTTOM
		)
