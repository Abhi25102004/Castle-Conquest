extends Goblin_Class  # Inherit from base Goblin class

signal GiveDamageToKnight  # Signal to notify a knight to take damage

# Called when a Knight enters this Goblin's hurtbox (collision area)
func HurtBox_Entered(area: Area2D) -> void:
	Knight_Array.append(area.get_parent())  # Add the Knight to the list of targets
	# Connect the custom signal to the Knight's damage-taking method
	GiveDamageToKnight.connect(Callable(area.get_parent(), "Take_Damage_from_Goblin"))

# Called when a Knight exits this Goblin's hurtbox
func HurtBox_Exited(area: Area2D) -> void:
	Knight_Array.erase(area.get_parent())  # Remove the Knight from the target list
	# Disconnect the signal so this Goblin stops sending damage to that Knight
	GiveDamageToKnight.disconnect(Callable(area.get_parent(), "Take_Damage_from_Goblin"))

# Called when the Goblin attacks
func OnAttack() -> void:
	if !Knight_Array.is_empty():  # Check if there's a Knight to attack
		GiveDamageToKnight.emit(Attack)  # Emit the damage signal with the Goblin's attack power
		GoblinDied.emit()                # Optional: this Goblin dies after attacking (suicide attacker?)
		call_deferred("queue_free")      # Safely remove the Goblin node from the scene

# Sets the Goblin's stats depending on the difficulty
func Stats_Setter() -> void:
	Cost = 100                           # Deployment or spawn cost
	Speed = randf_range(119, 121)        # Slight variation in movement speed
	Attack_Speed = 0                     # Used in some attack timing logic (if applicable)
	
	# Adjust stats based on the current game difficulty
	match Global.Difficulty:
		"Easy":
			Health = 120
			Attack = 40
		"Medium":
			Health = 140
			Attack = 50
		"Hard":
			Health = 160
			Attack = 60
