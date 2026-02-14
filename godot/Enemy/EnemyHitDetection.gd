extends Area3D

func take_damage(num):
	get_parent().get_parent().take_damage(num)
