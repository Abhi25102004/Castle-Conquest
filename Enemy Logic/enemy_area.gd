extends Area2D

class_name Enemy_Area

signal Update_Priority

var Current_Characters : Array[Node2D]

@onready var timer: Timer = Timer.new()

func _ready() -> void:
	add_child(timer)

	self.area_entered.connect(func(area: Area2D):
		Current_Characters.append(area.get_parent())
	)

	self.area_exited.connect(func(area: Area2D):
		Current_Characters.erase(area.get_parent())
	)

	timer.timeout.connect(func():
		var Total_value : float = 0
		
		for character in Current_Characters:
			if character is Knight_Class:
				if character.Health > 0:
					Total_value += character.Health * character.Points
			elif character is Goblin_Class:
				if character.Health > 0:
					Total_value += character.Health * character.Points

		Update_Priority.emit(Total_value)

		timer.start()
	)

	timer.start()
