extends Knight_Class  # Inherits from the custom base Knight class

# Function to set initial stats for this character
func Stats_Setter() -> void:
	Cost = 60                         # Cost to deploy this unit
	Character_value = 5              # Identifier or value used for game logic or classification
	Attack = 0                       # No attack ability (this unit is likely defensive only)
	Attack_Speed = 0                # No need for attack timing since it doesn't attack

	# Set health based on the current global difficulty setting
	match Global.Difficulty:
		"Easy":
			Health = 300
		"Medium":
			Health = 280
		"Hard":
			Health = 250

# Function called when the character is damaged by a goblin
func Take_Damage_from_Goblin(Power : float) -> void:
	Knight = States.Attack     # Set the state to "Attack" just for animation feedback
	Health -= Power            # Reduce health based on goblin's power

# Returns the name of the animation to play based on the current state
func getAnimation_String() -> String:
	match Knight:
		States.Idle:
			return "Idle"
		States.Attack:
			return "Attack"
		States.Death:
			return "Death"
	return ""  # Default return if no state matches

# Main loop handling character behavior every frame/tick
func Game_Loop() -> void:
	match Knight:
		States.Idle:
			# Play idle animation when not doing anything
			Animations.play(Animation_String)
		States.Attack:
			# Wait for attack cooldown (useless here since Attack_Speed is 0)
			await get_tree().create_timer(Attack_Speed).timeout
			Animations.play(Animation_String)         # Play attack animation
			await Animations.animation_finished        # Wait until it's done
			Knight = States.Idle                       # Return to idle
		States.Death:
			# Handle death: play animation, emit signal, and remove node
			Animations.play(Animation_String)
			await Animations.animation_finished
			KnightDied.emit()
			call_deferred("queue_free")               # Safely free the node

	Game_State = true  # Mark that game logic has executed for this frame
