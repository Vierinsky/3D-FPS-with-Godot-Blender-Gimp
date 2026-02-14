extends CharacterBody3D

var current_state = "idle"
var next_state = "idle"
var previous_state

@onready var player
func _ready():
	player = get_tree().get_first_node_in_group("player")
	nav.path_desired_distance = 0.5
	nav.target_desired_distance = 0.8
	print(player)

func _physics_process(delta):
	if previous_state != current_state:
		$StateLabel.text = current_state
	
	previous_state = current_state
	current_state = next_state
	
	match current_state:
		"idle":
			idle()
		"chase":
			chase(delta)
		"bite":
			bite()

func take_damage(num):
	print("We took ", num, " damage.")

@onready var nav = $NavigationAgent3D
@onready var speed=3.0

#func chase(delta: float) -> void:
	#var dir: Vector3 = (player.global_position - global_position)
	#dir.y = 0
	#dir = dir.normalized()
#
	#velocity.x = dir.x * speed
	#velocity.z = dir.z * speed
	#move_and_slide()

func chase(delta: float) -> void:
	nav.target_position = player.global_position
	
	if nav.target_position.distance_to(player.global_position) > 0.2:
		nav.target_position = player.global_position

	var next_pos: Vector3 = nav.get_next_path_position()
	var dir: Vector3 = next_pos - global_position
	dir.y = 0.0

	# Si el agente no te da un siguiente punto útil, persigue directo (fallback)
	if dir.length() < 0.05:
		dir = player.global_position - global_position
		dir.y = 0.0

	if dir.length() > 0.001:
		dir = dir.normalized()
		velocity.x = dir.x * speed
		velocity.z = dir.z * speed
	else:
		velocity.x = 0.0
		velocity.z = 0.0
		
	#print("finished:", nav.is_navigation_finished(),
	  #" dist_to_next:", nav.get_next_path_position().distance_to(global_position),
	  #" dist_to_player:", player.global_position.distance_to(global_position))

	move_and_slide()

#func chase(delta):
	## 1) Actualiza el objetivo primero (Vector3)
	#nav.target_position = player.global_position
	#
	## 2) Siguiente punto del path (Vector3)
	#var next_pos: Vector3 = nav.get_next_path_position()
	## 3) Dirección hacia el siguiente punto (Vector3)
	#var dir: Vector3 = next_pos - global_position
	#
	## (Opcional, pero recomendado en 3D) no persigas en Y
	#dir.y=0.0
	#
	#if dir.length() > 0.001:
		#dir = dir.normalized()
		#
	## 4) Aplica velocidad (NO uses delta aquí)
	#if player.global_position.distance_to(global_position) > 1.0:
		#velocity.x = dir.x * speed
		#velocity.z = dir.z * speed
	#else:
		#velocity.x = 0.0
		#velocity.z = 0.0
		#
	## 5) Mueve el CharacterBody3D
	#move_and_slide()

func idle():
	next_state="chase"
	if previous_state != current_state:
		$Enemy/AnimationPlayer.play("Rest")
	
	
func bite():
	if previous_state != current_state:
		$Enemy/AnimationPlayer.play("Bite")
		
func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		next_state = "bite"


func _on_area_3d_body_exited(body):
	if body.is_in_group("player"):
		next_state = "idle"
