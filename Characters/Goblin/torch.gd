extends Goblin_Class  # Inheriting from the Goblin_Class to gain basic Goblin behavior

signal GiveDamageToKnight  # Signal that will be used to give damage to a Knight when triggered

# Called when the HurtBox (collision area) of the Goblin overlaps with another area (typically a Knight)
func HurtBox_Entered(area: Area2D) -> void:
	Knight_Array.append(area.get_parent())  # Add the Knight to the list of Knights in range
	# Connect the GiveDamageToKnight signal to the 'Take_Damage_from_Goblin' method of the Knight
	GiveDamageToKnight.connect(Callable(area.get_parent(), "Take_Damage_from_Goblin"))

# Called when the HurtBox (collision area) of the Goblin stops overlapping with an area (Knight)
func HurtBox_Exited(area: Area2D) -> void:
	Knight_Array.erase(area.get_parent())  # Remove the Knight from the list of Knights in range
	# Disconnect the GiveDamageToKnight signal from the Knight's 'Take_Damage_from_Goblin' method
	GiveDamageToKnight.disconnect(Callable(area.get_parent(), "Take_Damage_from_Goblin"))

# Called when the Goblin attacks
func OnAttack() -> void:
	if !Knight_Array.is_empty():  # Check if there are Knights in range
		GiveDamageToKnight.emit(Attack)  # Emit the signal to deal damage to the first Knight in the list

# Function to set the Goblin's stats based on the game difficulty
func Stats_Setter() -> void:
	Cost = 50  # The cost to deploy this Goblin
	Speed = randf_range(119, 121)  # Randomize the Goblin's speed within a given range
	# Set stats based on the current game difficulty
	match Global.Difficulty:
		"Easy":
			Health = 80  # Goblin health for easy difficulty
			Attack = 20  # Goblin attack for easy difficulty
			Attack_Speed = 1.2  # Attack speed for easy difficulty
		"Medium":
			Health = 100  # Goblin health for medium difficulty
			Attack = 25  # Goblin attack for medium difficulty
			Attack_Speed = 1.1  # Attack speed for medium difficulty
		"Hard":
			Health = 120  # Goblin health for hard difficulty
			Attack = 30  # Goblin attack for hard difficulty
			Attack_Speed = 1.0  # Attack speed for hard difficulty
