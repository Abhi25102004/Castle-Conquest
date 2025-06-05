extends Resource

class_name Achievement_Save

@export var Achievements : Dictionary[int, Dictionary] = {
	1: {
		"completed": false,
		"notified": false,
		"name": "1. First Blood",
		"description": "Defeat your first goblin and defend the castle! : Complete Level 1"
	},
	2: {
		"completed": false,
		"notified": false,
		"name": "2. Halfway Hero",
		"description": "You've proven your mettle. The realm is halfway safe! : Complete Level 10"
	},
	3: {
		"completed": false,
		"notified": false,
		"name": "3. Squire's Triumph",
		"description": "The journey was light, but victory is still sweet. : Complete the Game in Easy Mode"
	},
	4: {
		"completed": false,
		"notified": false,
		"name": "4. Knight of the Realm",
		"description": "You've fought bravely and emerged victorious. : Complete the Game in Medium Mode"
	},
	5: {
		"completed": false,
		"notified": false,
		"name": "5. Champion of Castle Conquest",
		"description": "Only legends stand where you stand now. Glory is yours! : Complete the Game in Hard Mode"
	}
}
