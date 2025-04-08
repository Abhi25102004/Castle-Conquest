extends Button

@export var Level_number : int 
@export var Level_data : Level_Information

@onready var label: Label = $Label

func _ready() -> void:
	label.text = "Level : " + str(Level_number)
