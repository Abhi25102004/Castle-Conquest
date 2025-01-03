extends Marker2D

@onready var selection_animation: AnimatedSprite2D = $AnimatedSprite2D

var Reserved : bool = false 

func Check_Distance() -> float:
	return global_position.distance_squared_to(get_global_mouse_position())

func Enable_Selection() -> void:
	selection_animation.play("select")
	selection_animation.visible = true

func Disable_Selection() -> void:
	selection_animation.stop()
	selection_animation.visible = false
