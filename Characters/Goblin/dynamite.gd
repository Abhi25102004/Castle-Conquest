extends Node2D  # Inheriting from Node2D to make this an object that can be placed in the 2D scene

var Attack : int  # The attack damage value for the arrow
var Vertical_speed : int = 550  # Speed at which the arrow moves vertically (on the x-axis in this case)
var Rotation_speed : int = 10  # Speed of the arrow's rotation
var wait_time : float = 5  # Time before the arrow disappears after being shot

@onready var Animations: AnimatedSprite2D = $AnimatedSprite2D  # Get reference to the AnimatedSprite2D node for animation control

# Called every frame to update the arrow's movement
func _process(delta: float) -> void:
	position += Vector2(-1,0) * Vertical_speed * delta  # Moves the arrow leftward (horizontal movement)
	rotation += Rotation_speed * delta  # Rotates the arrow at a constant speed
	wait_time -= delta  # Decrease the wait time until the arrow is removed
	if wait_time <= 0:  # Once the wait time expires, remove the arrow from the scene
		call_deferred("queue_free")

# This function is called when the arrow collides with an area (like a Knight)
func Remove_Arrow(area: Area2D) -> void:
	# Check if the object that the arrow collided with has a method for taking damage
	if area.get_parent().has_method("Take_Damage_from_Goblin"):
		Vertical_speed = 0  # Stop the arrow's movement when it hits
		Rotation_speed = 0  # Stop the rotation of the arrow
		area.get_parent().Take_Damage_from_Goblin(Attack)  # Apply the attack damage to the object
		Animations.play("Blast")  # Play a "Blast" animation (maybe an explosion effect)
		await Animations.animation_finished  # Wait for the animation to finish before continuing
		call_deferred("queue_free")  # Safely remove the arrow from the scene after the animation
