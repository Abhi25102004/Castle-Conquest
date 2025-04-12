extends Knight_Class  # Inherits from the base Knight_Class

# Sets the basic stats for this character
func Stats_Setter() -> void:
	Health = 50              # Lower health for this specific character
	Attack = 0               # No attack capability
	Attack_Speed = 0         # No attacking speed (won’t be used)
	Cost = 40                # Coin cost to place this unit
	Character_value = 3      # Identifier or value tag for sorting/spawning logic

# Called when this character takes damage from a Goblin
func Take_Damage_from_Goblin(Power : float) -> void:
	Knight = States.Attack   # Play attack animation (maybe this is a 'hurt' reaction?)
	Health -= Power          # Subtract goblin's attack power from health

# Called when a Goblin enters this unit's HurtBox (area-based collision detection)
func HurtBox_Entered(area: Area2D) -> void:
	if area.get_parent() is Goblin_Class:      # If the collider belongs to a Goblin
		Goblin_Array.append(area.get_parent()) # Track that goblin in the list

# Returns the appropriate animation string based on the current state
func getAnimation_String() -> String:
	match Knight:
		States.Idle:
			return "Idle"   # Default animation
		States.Attack:
			return "Attack" # Used when hit
		States.Death:
			return "Death"  # Death animation
	return ""  # Fallback return

# Main behavior loop for the character, executed once per frame when Game_State is true
func Game_Loop() -> void :
	match Knight:
		States.Idle:
			Animations.play(Animation_String)  # Play idle animation

		States.Attack:
			await get_tree().create_timer(Attack_Speed).timeout  # Wait (no delay here since it's 0)
			Animations.play(Animation_String)                    # Play attack/hurt animation
			await Animations.animation_finished                  # Wait till it's done
			Knight = States.Idle                                 # Go back to idle

		States.Death:
			HitBox_CollisionShape.disabled = true                # Disable further collisions
			Goblin_Array[0].HurtBox_CollisionShape.disabled = true  # Prevent goblin from interacting again
			Goblin_Array[0].Direction = 1                         # Flip goblin to go back (change direction)
			Goblin_Array[0].Animations.flip_h = false             # Reset goblin sprite direction
			Animations.play(Animation_String)                     # Play death animation
			Animations.scale = Vector2(1.3, 1.3)                   # Visually enlarge the character
			await Animations.animation_finished                   # Wait for animation to complete
			KnightDied.emit()                                     # Signal that this knight has died
			call_deferred("queue_free")                           # Delete the node safely

	Game_State = true  # Reset game state flag so it can loop again next frame
