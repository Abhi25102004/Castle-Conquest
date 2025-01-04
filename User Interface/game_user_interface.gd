extends CanvasLayer

@onready var grids: GridContainer = $Grid

signal Place_Character

func _ready() -> void:
	for grid in grids.get_children():
		grid.Button_Was_Pressed.connect(Callable(self,"Placement_connector"))

func Placement_connector(character : String) -> void:
	Place_Character.emit(character)
