extends Node2D

@export var PlayerCharacter : PackedScene
@export var MarksPosition : Array[float]

func _input(_event: InputEvent) -> void:
    if Input.is_action_just_pressed("MouseClick"):
        var MinDistance : float = 999
        for index in range(0,MarksPosition.size()):
            if get_global_mouse_position().distance_to(MarksPosition[index]
            
            