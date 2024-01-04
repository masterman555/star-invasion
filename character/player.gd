extends CharacterBody2D

signal health_depleted

var health = 100.0

func _physics_process(delta):
		# left = negative x, right = positive x, up = negative y, down = positive y
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down") 
	velocity = direction * 500
	move_and_slide()
	
	if velocity.length() > 0.0:
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
