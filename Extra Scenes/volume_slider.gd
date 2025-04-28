extends HSlider

@export var Bus_name : String
var Bus_index : int

func _ready() -> void:
	Bus_index = AudioServer.get_bus_index(Bus_name)
	
	value_changed.connect(func(Sound_value : float):
		AudioServer.set_bus_volume_db(Bus_index,linear_to_db(Sound_value))
		var SaveFile : Level_Selection = ResourceLoader.load("user://Level_Details.tres")
		SaveFile.Audio[Bus_name] = Sound_value
		ResourceSaver.save(SaveFile,"user://Level_Details.tres")
		)
	
	value = db_to_linear(AudioServer.get_bus_volume_db(Bus_index))
