extends Button

@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label

@export var image : CompressedTexture2D 
@export var value : String
@export var Character : String

signal Button_Was_Pressed

func _ready() -> void:
	texture_rect.texture = image
	label.text = value
	self.pressed.connect(Callable(self,"Pressed"))

func Pressed() -> void:
	Button_Was_Pressed.emit(Character)
