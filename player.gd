extends Area2D

signal  hit

@export var speed: float = 400.0
var screen_size = Vector2.ZERO

func _ready():
	screen_size = get_viewport().get_visible_rect().size
	hide()

func _physics_process(delta):
	var direction = Vector2.ZERO

	# Input
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	if Input.is_action_pressed("move_up"):
		direction.y -= 1

	# Normalize for diagonal
	if direction.length() > 1:
		direction = direction.normalized()

	# Animate based on direction
	if direction != Vector2.ZERO:
		if abs(direction.x) > abs(direction.y):
			$AnimatedSprite2D.animation = "Right"
			$AnimatedSprite2D.flip_h = direction.x < 0
			$AnimatedSprite2D.flip_v = false
		else:
			$AnimatedSprite2D.animation = "Up"
			$AnimatedSprite2D.flip_v = direction.y > 0
			$AnimatedSprite2D.flip_h = false
		
		$AnimatedSprite2D.play()  # Call AFTER setting animation
	else:
		$AnimatedSprite2D.stop()

	# Movement
	position += direction * speed * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
func start(new_position: Vector2) -> void:
	position = new_position
	show()
	$CollisionShape2D.disabled = false
	
func _on_body_entered(body: Node2D) -> void:
	hide()
	$CollisionShape2D.set_deferred("disabled", true)
	$CollisionShape2D.disabled = true
	emit_signal("hit")
