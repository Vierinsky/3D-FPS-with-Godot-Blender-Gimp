extends CharacterBody3D

var current_state = "idle"
var next_state = "idle"
var previous_state

@onready var player
func _ready():
	player = get_tree().get_first_node_in_group("player")
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
@onready var nav = $NavigationAgent3D
@onready var speed=3.0
	
func chase(delta):
	velocity = (nav.get_next_path_position() - position).normalized() * speed * delta
	
	if player.position.distance_to(self.position) > 1:
		nav.target_position = player.position
		move_and_collide(velocity)

func idle():
	next_state="chase"
	if previous_state != current_state:
		$Enemy/AnimationPlayer.play("Rest")
	
	
func bite():
	if previous_state != current_state:
		$Enemy/AnimationPlayer.play("Bite")
	
#func chase():
	#print("We are chasing")
	#if Input.is_action_just_pressed("a"):
		#next_state = "idle"
	## All of our movement code would be here
	
func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		next_state = "bite"


func _on_area_3d_body_exited(body):
	if body.is_in_group("player"):
		next_state = "idle"
