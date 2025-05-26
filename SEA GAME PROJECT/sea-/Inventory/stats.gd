extends TextureRect

@export var slot_type: int = 0

@export var ATK = 0:
	set(value):
		ATK = value
		%debug.text = str(ATK)
		
		
		
@onready var property: Dictionary = {"TEXTURE": texture, "ATK": ATK, "SLOT_TYPE": slot_type}:
	
	set(value):
		property = value
		
		texture = property["TEXTURE"]
		ATK = property["ATK"]
		slot_type = property["SLOT_TYPE"]
