extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0
# Define length of Coyote time
const COYOTE_TIME = 10
# Define length of jump buffer
const JUMP_BUFFER = 10
const PUSH_FORCE = 50

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var coy = COYOTE_TIME
var JumpBuffer = 0

@onready var animated_sprite = $AnimatedSprite2D
@onready var attack = $"AnimatedSprite2D/Swing/AnimationPlayer"

func _ready():
	$"AnimatedSprite2D/Swing/CollisionShape2D".disabled = true

func _physics_process(delta):	
	# Add the gravity.
	if not is_on_floor():
		coy -= 1
		JumpBuffer -= 1
		velocity.y += gravity * delta
	else:
		coy = COYOTE_TIME

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		if (is_on_floor() or coy > 0):
			velocity.y = JUMP_VELOCITY
			coy = 0
		else:
			# If the player jumps while on the air buffer the jump
			JumpBuffer = JUMP_BUFFER
	
	# Jump if the player has a buffered jump
	if (is_on_floor() and JumpBuffer > 0):
		velocity.y = JUMP_VELOCITY
		coy = 0

	# Get the input direction: -1, 0, 1
	var direction = Input.get_axis("move_left", "move_right")
	
	# Flip the Sprite
	if direction > 0:
		animated_sprite.scale.x = 1
	elif direction < 0:
		animated_sprite.scale.x = -1
		
	# Attack
	if Input.is_action_just_pressed("attack"):
		attack.play("Attack")
	
	# Play animations
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
	
	# Apply movement
	if direction:
		velocity.x = direction * SPEED
		# Apply force to objects
		for i in get_slide_collision_count():
			var coll = get_slide_collision(i)
			if coll.get_collider() is RigidBody2D:
				coll.get_collider().apply_central_impulse(-coll.get_normal() * PUSH_FORCE)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func die():
	# Play the death animation
	animated_sprite.play("die")
	# disable player controls
	set_process(false)
	set_physics_process(false)
	# restart level after some time
	print("You died!")
	Engine.time_scale = 0.3 
	await get_tree().create_timer(0.4).timeout
	
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()

func _on_swing_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if area.is_in_group("enemies"):
		area.die()
