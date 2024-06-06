extends Path2D

@onready var path = $PathFollow2D
@onready var animation = $AnimationPlayer

@export var loop = false
@export var speed = 1.0

func _ready():
	if not loop:
		animation.play("Movement")
		animation.speed_scale = speed
