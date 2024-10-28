extends CharacterBody3D

class_name monster
const SPEED = 3.0
const SPEEDUP_THRESHOLD = 30
@onready var player = get_parent().get_node("player")
@export var turn_speed = 4.0

func _ready() -> void:
	pass

func get_path_length():
	var path = $NavigationAgent3D.get_current_navigation_path()
	var total_distance = 0
	for i in range(path.size() - 1):
		total_distance += path[i].distance_to(path[i+1])
	return total_distance
	
func _physics_process(delta):
	$NavigationAgent3D.set_target_position(player.global_transform.origin)
	get_path_length()
	# Get the next position along the path
	var next_position = $NavigationAgent3D.get_next_path_position()
	if next_position != Vector3.ZERO:
		# Calculate the direction to the next waypoint
		var direction = (next_position - global_transform.origin).normalized()

		# Rotate smoothly towards the next waypoint
		var target_rotation = atan2(direction.x, direction.z)
		rotation.y = lerp_angle(rotation.y, target_rotation, turn_speed * delta)

		# Move forward in the facing direction
		var forward = transform.basis.z
		var velocity = forward * SPEED
		if get_path_length() > SPEEDUP_THRESHOLD:
			set_velocity(10 * velocity)
		else:
			set_velocity(velocity)
		move_and_slide()
	else:
		# No path found or at target position
		velocity = Vector3.ZERO
	