extends HSlider

@export var Bus_name : String
var Bus_index : int

func _ready() -> void:
	Bus_index = AudioServer.get_bus_index(Bus_name)
	
	value_changed.connect(func(Sound_value : float):
		AudioServer.set_bus_volume_db(Bus_index,linear_to_db(Sound_value))
		var Setting_File : Settings_Save = ResourceLoader.load("user://Settings_File.tres")
		Setting_File.Sound_Controller[Bus_name] = Sound_value
		ResourceSaver.save(Setting_File,"user://Settings_File.tres")
		)
	
	value = db_to_linear(AudioServer.get_bus_volume_db(Bus_index))
