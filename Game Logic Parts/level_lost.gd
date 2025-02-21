extends CanvasLayer

@onready var label: Label = $Label

func Select_Title() -> void:
	label.text = [
"Thy quest hath faltered...",
"Defeat stains thy banner...",
"The enemy hath bested thee...",
"Alas! Thy kingdom weeps...",
"Honor lost, but not forgotten...",
"A bitter loss, yet hope remains...",
"Thy foes feast whilst thy warriors fall..."
].pick_random()
