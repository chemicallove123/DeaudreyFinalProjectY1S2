extends Area2D

@onready var slime = get_parent()

func die():
	slime.die()
