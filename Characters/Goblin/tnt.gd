extends Goblin_Class  # Inheriting from the Goblin_Class to inherit behavior from the Goblin

var Dynamite : PackedScene = preload("res://Characters/Goblin/dynamite.tscn")  # Preload the Dynamite scene (the object the Goblin throws)

@onready var marker: Marker2D = $Marker2D  # Get a reference to the Marker2D node that will be used to position the dynamite

# Called when the HurtBox (collision area) of the Goblin collides with another area (like a Knight)
func HurtBox_Entered(area: Area2D) -> void:
	Knight_Array.append(area.get_parent())  # Add the Knight to the array of Knights that this Goblin can attack

# Called when the HurtBox (collision area) of the Goblin stops colliding with an area (like a Knight)
func HurtBox_Exited(area: Area2D) -> void:
	Knight_Array.erase(area.get_parent())  # Remove the Knight from the array of Knights

# Called when the Goblin is ready to attack
func OnAttack() -> void:
	if !Knight_Array.is_empty():  # Check if there are any Knights to attack
		var Dynamite_instance : Node2D = Dynamite.instantiate()  # Create an instance of the dynamite
		Dynamite_instance.Attack = Attack  # Set the Attack value on the dynamite instance
		Dynamite_instance.position = marker.position  # Set the dynamite’s position to the marker (which is typically where the attack happens)
		call_deferred("add_child", Dynamite_instance)  # Add the dynamite instance as a child of this Goblin (making it part of the scene)

# Function to set the Goblin's stats based on the game difficulty
func Stats_Setter() -> void:
	Cost = 75  # Cost to deploy this Goblin
	Speed = randf_range(79, 81)  # Set a random speed for the Goblin’s movement
	# Set stats based on the global difficulty setting
	match Global.Difficulty:
		"Easy":
			Health = 60  # Goblin health for easy difficulty
			Attack = 25  # Goblin attack for easy difficulty
			Attack_Speed = 1.5  # Attack speed for easy difficulty
		"Medium":
			Health = 80  # Goblin health for medium difficulty
			Attack = 30  # Goblin attack for medium difficulty
			Attack_Speed = 1.3  # Attack speed for medium difficulty
		"Hard":
			Health = 90  # Goblin health for hard difficulty
			Attack = 35  # Goblin attack for hard difficulty
			Attack_Speed = 1.2  # Attack speed for hard difficulty
