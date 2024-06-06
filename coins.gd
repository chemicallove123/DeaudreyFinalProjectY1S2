extends Area2D

@onready var game_manager = $"/root/Game/GameManager"
#@onready var animation_player = $AnimationPlayer
@onready var sound = $"/root/Game/PickupSound"

func _on_body_entered(body):
	game_manager.add_point()
	sound.play()
	self.queue_free()


