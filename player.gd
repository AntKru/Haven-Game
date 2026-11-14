extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var bounce = false

signal damage

func start(pos):
	bounce = false
	position = pos
	$AnimatedSprite2D.flip_h = true
	$CollisionShape2D.disabled = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		$AnimatedSprite2D.play()
		if direction > 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		$AnimatedSprite2D.stop()

	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider is TileMapLayer:
			if bounce:
				velocity = velocity.bounce(collision.get_normal())
			var cell: Vector2i = collider.local_to_map(collider.to_local(collision.get_position()) + Vector2(3, 0))
			var data = collider.get_cell_tile_data(cell)

			if data:
				if data.get_custom_data("spike"):
					$CollisionShape2D.disabled = true
					damage.emit()
					break
				elif data.get_custom_data("mushroom"):
					bounce = true;
			else:
				bounce = false;
	move_and_slide()
