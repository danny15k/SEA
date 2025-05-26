extends Sprite2D


@export var ID = "0"

func _ready():
	texture = load("res://sprite/Inventory/Item/" + ItemData.get_texture(ID))


func _on_body_entered(body: Node2D) -> void:
	get_parent().find_child("Inventory").add_item(ID)
	queue_free()
