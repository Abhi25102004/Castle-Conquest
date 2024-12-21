extends Node2D

var MarksPosition : Array[Vector2] = [
	Vector2(-853.33, -432.00), Vector2(-640.00, -432.00), Vector2(-426.67, -432.00), Vector2(-213.33, -432.00), Vector2(0.00, -432.00), Vector2(213.33, -432.00), Vector2(426.67, -432.00), Vector2(640.00, -432.00), Vector2(853.33, -432.00),
	Vector2(-853.33, -216.00), Vector2(-640.00, -216.00), Vector2(-426.67, -216.00), Vector2(-213.33, -216.00), Vector2(0.00, -216.00), Vector2(213.33, -216.00), Vector2(426.67, -216.00), Vector2(640.00, -216.00), Vector2(853.33, -216.00),
	Vector2(-853.33, 0.00), Vector2(-640.00, 0.00), Vector2(-426.67, 0.00), Vector2(-213.33, 0.00), Vector2(0.00, 0.00), Vector2(213.33, 0.00), Vector2(426.67, 0.00), Vector2(640.00, 0.00), Vector2(853.33, 0.00),
	Vector2(-853.33, 216.00), Vector2(-640.00, 216.00), Vector2(-426.67, 216.00), Vector2(-213.33, 216.00), Vector2(0.00, 216.00), Vector2(213.33, 216.00), Vector2(426.67, 216.00), Vector2(640.00, 216.00), Vector2(853.33, 216.00),
	Vector2(-853.33, 432.00), Vector2(-640.00, 432.00), Vector2(-426.67, 432.00), Vector2(-213.33, 432.00), Vector2(0.00, 432.00), Vector2(213.33, 432.00), Vector2(426.67, 432.00), Vector2(640.00, 432.00), Vector2(853.33, 432.00)
]

func _ready() -> void:
	for vector in MarksPosition:
		var marker : Marker2D = Marker2D.new()
		marker.position = vector
		add_child(marker)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("MouseClick"):
		var DistanceVector : Array[float] = []
		var MousePosition : Vector2 = get_global_mouse_position()
		for vector in MarksPosition:
			DistanceVector.append(MousePosition.distance_to(vector))
		var PlacementVector : Vector2 = MarksPosition[DistanceVector.find(DistanceVector.min())]
		var sprite : Sprite2D = Sprite2D.new()
		sprite.texture = load("res://icon.svg")
		sprite.global_position = PlacementVector
		add_child(sprite)
		
			
		
