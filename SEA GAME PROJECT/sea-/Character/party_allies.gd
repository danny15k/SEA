extends Node2D

var party_members = []  # List of all party members
var leader = null  # The current leader
var position_queues = []  # Stores previous positions for followers
var last_leader_position = Vector2.ZERO  # Tracks last valid position
var last_leader_direction = Vector2.DOWN  # Default direction when idle

const FOLLOW_DISTANCE = 20 # Space between each party member
const MAX_QUEUE_SIZE = 10  # Controls how smooth the following is
const FOLLOW_SPEED = 0.15  # Controls how smoothly followers move (higher = slower)

func _ready():
	party_members = [$player_captain, $player_girl, $player_boy]
	leader = party_members[0]  # Set the first member as the leader

	# Initialize position queues for each follower
	position_queues.resize(party_members.size())
	for i in range(party_members.size()):
		position_queues[i] = []

	# Assign different collision layers
	for member in party_members:
		member.set_collision_layer_value(1, false)  # Remove from main collision layer
		member.set_collision_layer_value(2, true)   # Assign to a special party-only layer

	# Leader can collide with everything except party members
	leader.set_collision_mask_value(1, true)  # Collide with walls/objects
	leader.set_collision_mask_value(2, false) # Walk through companions

	# Companions still collide with the environment
	for follower in party_members:
		if follower != leader:
			follower.set_collision_mask_value(1, true)  # Collide with walls/objects
			follower.set_collision_mask_value(2, false) # Ignore other companions

	# Store leader's initial position
	last_leader_position = leader.global_position

func _process(delta):
	# Get leader's movement direction
	var leader_velocity = Vector2.ZERO
	if leader is CharacterBody2D:
		leader_velocity = leader.velocity

	# Sort characters by Y position (default behavior)
	for member in party_members:
		member.z_index = int(member.global_position.y)

	# ✅ Adjust Z-index when moving UP or DOWN
	if leader_velocity.y < 0:  # Moving UP
		leader.z_index = -1  # Ensure leader is BEHIND followers
	elif leader_velocity.y > 0:  # Moving DOWN
		leader.z_index = 999  # Ensure leader is IN FRONT

	# ✅ Check if the leader has moved
	var leader_has_moved = leader_velocity.length() > 0 and leader.global_position != last_leader_position

	if leader_has_moved:
		last_leader_position = leader.global_position
		last_leader_direction = leader_velocity.normalized()  # Update last direction

		# ✅ Store leader's position for followers
		position_queues[0].push_front(leader.global_position)

		# Limit queue size
		if position_queues[0].size() > MAX_QUEUE_SIZE:
			position_queues[0].pop_back()

	# ✅ Move followers smoothly
	for i in range(1, party_members.size()):
		var follower = party_members[i]
		var target_position

		# If leader is moving, follow normally
		if leader_has_moved:
			var leader_position = position_queues[i - 1][-1] if position_queues[i - 1].size() > 0 else party_members[i - 1].global_position
			target_position = leader_position - (last_leader_direction * FOLLOW_DISTANCE)
		else:
			# ✅ If leader stops, followers settle naturally without snapping
			target_position = party_members[i - 1].global_position - (last_leader_direction * FOLLOW_DISTANCE)

		# ✅ Use LERP for natural movement, slowing down over time
		follower.global_position = follower.global_position.lerp(target_position, FOLLOW_SPEED)

		# Store position history
		position_queues[i].push_front(follower.global_position)
		if position_queues[i].size() > MAX_QUEUE_SIZE:
			position_queues[i].pop_back()
		
		
			
	
