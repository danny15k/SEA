extends Area2D

var active = false

@export var dialogue_resource : DialogueResource
@export var dialogue_start : String = "Dialogue_1"
const Balloon =preload("res://Dialogue/balloon.tscn")

func action() -> void:
	var balloon: Node = Balloon.instantiate()
	get_tree().current_scene.add_child(balloon)
	balloon.start(dialogue_resource, dialogue_start) 
	
