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
			if can_fire:
				if ammo_in_gun>0:
					fire()
				else:
					reload()

func reload():
	can_fire = false
	# This part handles the ammo
	var rounds_needed = max_rounds_in_gun - ammo_in_gun
	
	if ammo_in_inventory > rounds_needed:
		ammo_in_inventory -= rounds_needed
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
	
	for ray in $RayHolder.get_children():
		if ray.is_colliding():
			print(ray.get_collider())
			if ray.get_collider().is_in_group("enemy"):
				ray.get_collider().take_hit()

func _on_animation_player_animation_finished(anim_name):
	print("anim_name = ", anim_name)
	if anim_name == "Fire":
		$AnimationPlayer.play("Pump")
		$PumpSound.play()
		
	if anim_name == "Pump":
		can_fire = true
		
	if anim_name == "Reload":
		can_fire = true
