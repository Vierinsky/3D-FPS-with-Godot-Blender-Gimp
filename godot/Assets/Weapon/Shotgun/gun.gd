extends Node3D

@onready var can_fire = true
# We'll use this when we have multiple weapons to switch to
@onready var active_weapon = true

# ammo vars
@onready var max_rounds_in_gun = 3
@onready var ammo_in_gun = 3
@onready var ammo_in_inventory = 6


func _process(delta):
	if active_weapon:
		if Input.is_action_just_pressed("reload"):
			if can_fire:
				reload()
		if Input.is_action_just_pressed("fire"):
			if can_fire():
				if ammo_in_gun>0:
					fire()
				else:
					reload()

func reload():
	can_fire = false
	# This part handles the ammo
	var rounds_needed = max_rounds_in_gun - ammo_in_gun
	
	if ammo_in_inventory > rounds_needed:
		ammo_in_invenory -= rounds_needed
		ammo_in_gun = max_rounds_in_gun
	else:
		if ammo_in_inventory == 0:
			$DryFire.play()
			print("no ammo in inventory")
			can_fire = true
			return
		else:
			ammo_in_gun = ammo_in_inventory
			ammo_in_inventory = 0
	# This part plays the animation
	$AnimationPlayer.play("Reload")
	$Reload.play()
	
func fire():
	can_fire = false
	$GPUParticles3D.emitting = true
	ammo_in_gun -= 1
	print("ammo in gun = ", ammo_in_gun)
	print("ammo in inventory = ", ammo_in_inventory)
	$FireSound.play()
	$AnimationPlayer.play("Fire")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
