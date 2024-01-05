extends CharacterBody2D

signal health_depleted

var max_speed = 500
var accel = 5000
var friction = 1000
var health = 100.0
var input = Vector2.ZERO

func get_input():	
	input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	return input.normalized()


func _physics_process(delta):
		# left = negative x, right = positive x, up = negative y, down = positive y
	input = get_input()
	
	if input == Vector2.ZERO:
		#movement
		if velocity.length() > (friction * delta):
			velocity -= velocity.normalized() * (friction * delta)
		else:
			velocity = Vector2.ZERO
	else:
		velocity += (Input.get_vector("move_left", "move_right", "move_up", "move_down") * accel * delta)
		velocity = velocity.limit_length(max_speed)
	
	if velocity.length() > 0:
		#rotation
		rotation = velocity.angle() + PI/2
	
	
	if velocity.length() > 0.0:
		#idle/walking animation
		get_node("HappyBoo").play_walk_animation() # $HappyBoo.play_walk_animation - its the same
	else:
		get_node("HappyBoo").play_idle_animation()
	
	const DAMAGE_RATE = 50.0
	var overlapping_enemies = %Hitbox.get_overlapping_bodies()
	if overlapping_enemies.size() > 0:
		health -= DAMAGE_RATE * overlapping_enemies.size() * delta
		%ProgressBar.value = health
		if health < 0.0:
			health_depleted.emit()
	move_and_slide()
