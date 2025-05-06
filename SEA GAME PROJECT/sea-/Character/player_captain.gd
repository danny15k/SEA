extends CharacterBody2D

var speed := 100
@export var starting_direction: Vector2 = Vector2(0, 1)

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var actionable_finder: Area2D = $Direction/Actionablefinder

var can_move := true

func _ready():
	update_animation_parameters(starting_direction)
	var dialogue_manager = get_tree().get_current_scene().find_child("DialogueManager", true, false)
	if dialogue_manager and dialogue_manager.has_signal("dialogue_ended"):
		dialogue_manager.connect("dialogue_ended", Callable(self, "_on_dialogue_ended"))

func _physics_process(delta: float) -> void:
	if not can_move:
		velocity = Vector2.ZERO
		move_and_slide()
		pick_new_state()
		return

	var input_direction = Input.get_vector("left", "right", "up", "down")
	if input_direction.x != 0:
		input_direction.y = 0
	elif input_direction.y != 0:
		input_direction.x = 0

	velocity = input_direction * speed
	move_and_slide()
	update_animation_parameters(input_direction)
	pick_new_state()

func update_animation_parameters(move_input: Vector2):
	if move_input != Vector2.ZERO:
		animation_tree.set("parameters/walk/blend_position", move_input)
		animation_tree.set("parameters/idle/blend_position", move_input)

func pick_new_state():
	if velocity != Vector2.ZERO:
		state_machine.travel("walk")
	else:
		state_machine.travel("idle")

func _unhandled_input(event: InputEvent) -> void:
	if can_move and Input.is_action_just_pressed("ui_accept"):
		var actionables = actionable_finder.get_overlapping_areas()
		if actionables.size() > 0 and actionables[0].has_method("action"):
			can_move = false
			actionables[0].action()

# Note: Accept the resource argument!
func _on_dialogue_ended(resource):
	can_move = true
	
