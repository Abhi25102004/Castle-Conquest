extends CanvasLayer

@onready var label: Label = $Label

func Select_Title() -> void:
	label.text = [
"Patience, noble one...",
"Let time weave its course...",
"A moment’s respite, sire...",
"The fates must yet decide...",
"The scrolls are being scribed...",
"Hold fast, for destiny beckons...",
"Thy journey shall resume anon..."
].pick_random()
