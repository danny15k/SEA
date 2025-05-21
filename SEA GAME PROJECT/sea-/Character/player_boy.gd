class_name player_boy
extends CharacterBody2D

var speed = 100
@export var starting_direction : Vector2 = Vector2(0,1)

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")

var active := false
@onready var emotes = $Emotes2
@onready var anim = $Emotes2/Emote_animation
@onready var actionable_finder = $Actionables  # Area2D

func _ready():
	#update_animation_parameters(starting_direction)
	# show chat emotes
	actionable_finder.connect("body_entered", Callable(self, "_on_body_entered"))
	actionable_finder.connect("body_exited", Callable(self, "_on_body_exited"))
	

func _on_body_entered(body):
	if body.name == "Captain":
		active = true

func _on_body_exited(body):
	if body.name == "Captain":
		active = false

# Walk movement with 4-directional restriction
#func _physics_process(delta: float) -> void:
	#var input_direction = Input.get_vector("left", "right", "up", "down")
#
	## Restrict to only 4-directional movement (no diagonals)
	#if input_direction.x != 0:
		#input_direction.y = 0  # Prioritize horizontal movement
	#elif input_direction.y != 0:
		#input_direction.x = 0  # Otherwise, use vertical movement
#
	#update_animation_parameters(input_direction)
#
	## Update velocity
	#velocity = input_direction * speed
	#
	## Move and slide function uses velocity to move character
	#move_and_slide()
	#pick_new_state()
	
#func update_animation_parameters(move_input : Vector2):
	### Don't change animation parameters if there is no input
	##if move_input != Vector2.ZERO:
		##animation_tree.set("parameters/walk/blend_position", move_input)
		##animation_tree.set("parameters/idle/blend_position", move_input)

# State of the player
func pick_new_state():
	if velocity != Vector2.ZERO:
		state_machine.travel("walk")
	else: 
		state_machine.travel("idle")
#
## FOLLOW SYSTEM
#var follow_target = Vector2.ZERO  # Position to follow
#var follow_speed = 100  # Adjust for smooth trailing

func _process(delta):
	emotes.visible = active
	if active and not anim.is_playing():
		anim.play("chat")
	#var party_manager = get_parent()

		### Only the leader can switch leaders
		##if party_manager and party_manager.has_method("switch_leader"):
			##if self == party_manager.leader and Input.is_action_just_pressed("switch_leader"):
				##party_manager.switch_leader()
				##return  
#
	## If there's no follow target, do nothing
	#if not follow_target:
		#return  
#
	#var direction = (follow_target - global_position).normalized()
#
	## Restrict follower movement to 4 directions
	#if abs(direction.x) > abs(direction.y):
		#direction.y = 0  # Prioritize horizontal movement
	#else:
		#direction.x = 0  # Otherwise, use vertical movement
#
	#if global_position.distance_to(follow_target) > 5:
		#velocity = direction * follow_speed  # Move only in one direction
	#else:
		#velocity = Vector2.ZERO  # Stop moving if close enough
#
	#move_and_slide()
