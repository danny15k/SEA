extends Control

func _ready():
	visible = false  # Inventory starts closed

func _input(event):
	if event.is_action_pressed("Inventory"):
		visible = !visible  # Toggle visibility on press
