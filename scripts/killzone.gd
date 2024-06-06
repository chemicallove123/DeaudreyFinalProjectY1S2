extends Area2D

@onready var timer = $Timer
@onready var player = $"/root/Game/Player"

func _on_body_entered(body):
	if body.is_in_group("player"):
		player.die()

