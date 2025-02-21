extends CanvasLayer

@onready var label: Label = $Label

func Select_Title() -> void:
	label.text = [
"Victory is thine!",
"Thou hast prevailed!",
"Glory is yours, brave one!",
"A noble triumph!",
"Huzzah! The battle is won!",
"By steel and valor, thou art victorious!",
"The land sings of thy deeds!"
].pick_random()
