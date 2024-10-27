extends Node3D

@onready var monster_scene = preload("res://scenes/Monster.tscn")
var monster_in_scene = false

@onready var timer: Timer = $GameTimer
@onready var player = $player
var enemy = preload("res://enemy.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start()
func _physics_process(delta: float) -> void:
	get_tree().call_group("enemies","update_target_location",player.global_transform.origin)

func _process(delta: float) -> void:
	pass
		
func spawn_monster():
	var spawn_distance = 10.0 
	var random_offset_range = 5.0
	var random_offset = Vector3(
		(randf() * 2 - 1) * random_offset_range, 
		0,
		(randf() * 2 - 1) * random_offset_range  
	)

	# Calculate the spawn position behind the player
	var player_position = $player.global_transform.origin
	var player_direction = -$player.global_transform.basis.z.normalized()
	var spawn_position = player_position + (player_direction * spawn_distance) + random_offset

	# Instantiate the monster and set its position
	var monster_instance = monster_scene.instantiate()
	monster_instance.global_transform.origin = spawn_position
	add_child(monster_instance)
	
	monster_in_scene = true
	
func _on_monster_spawn_timer_timeout() -> void:
	if not monster_in_scene:
		spawn_monster()
		$monster_spawn_timer.wait_time = randi_range(1, 10)


func _on_game_timer_timeout() -> void:
	var player_pos = player.get_position()
	var instance = enemy.instantiate()
	instance.position = player_pos
	instance.position.x = instance.position.x-10
	#get_tree().create_timer(10.0).timeout
	add_child(instance)


func _on_player_gameover() -> void:
	get_tree().change_scene_to_file("res://End_Scene/End_Screen_Scenes/end_screen.tscn")
