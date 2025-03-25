extends Button

@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label

@export var image : CompressedTexture2D 
@export var value : int
@export var Scene : PackedScene

func _ready() -> void:
	if image != null:
		texture_rect.texture = image
	label.text = str(value)
