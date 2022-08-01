extends KinematicBody2D

export (int) var gravity_power
export (int) var jump_power
export (int) var speed

var velocity = Vector2.ZERO   #Vector2 (x0, y0)
# Código para el funcionamiento del enemigo del juego.

enum {IDLE, RESPIRAR, SALTO_UP, SALTO_DOWN}
var state
var current_anim
var new_anim


func _ready():
	randomize()
	set_timer_interval()
	 # Nodo Timer, para Jump/Saltar.
	$jumpTimer.wait_time = rand_range(4, 6)
	$jumpTimer.start()
	transition_to(IDLE)


func transition_to(new_state):
	state = new_state
	match (state):
		IDLE:
			new_anim = "idle"
		RESPIRAR:
			new_anim = "respirar"
		SALTO_UP:
			new_anim = "salto_Up"
		SALTO_DOWN:
			new_anim = "salto_Down"
		

func _process(delta):
	if new_anim != current_anim:
		current_anim = new_anim
		$AnimationPlayer.play(current_anim)
	
	if not is_on_floor():
		velocity.x = speed
	else:
		velocity.x = 0
	
	$Sprite.flip_h = (speed > 0)
	
	if not is_on_floor() and velocity.y > 0:
		transition_to(SALTO_DOWN)
		
	if is_on_floor() and state == SALTO_DOWN:
		transition_to(IDLE)
	
	
func _physics_process(delta):
	velocity.y += gravity_power * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	

func set_timer_interval():
	# Nodo Timer, para animación (IDLE/"respirar")
	var interval = rand_range(2, 4)
	$Timer.wait_time = interval
	$Timer.start()


# Función, para reproducir la animación de respiración (respiracion)
func _on_Timer_timeout():
	$Timer.stop()
	if state == IDLE:
		transition_to(RESPIRAR)
	#$AnimationPlayer.play("idle")
	set_timer_interval()


func _on_AnimationPlayer_animation_finished(anim_name):
	# Devolver la animación a IDLE (Solo cuando es "respírar")
	if anim_name == "respirar":
		transition_to(IDLE)


func _on_jumpTimer_timeout():
	$jumpTimer.stop()   # Se apaga JumpTimer.
	if state == IDLE:
		velocity.y = jump_power
		transition_to(SALTO_UP)
		update_speed_direction()
	# Se resetea JumpTimer y se duplica JumpTimer.
	set_timer_interval()
	$jumpTimer.wait_time = rand_range(4, 6)
	$jumpTimer.start()  


func update_speed_direction():
	var pulso = bool (randi() % 2) # Generará o bool 0 (Falso) / bool 1 (True).
	
	if pulso == true:   # True
		speed = speed * -1
	else:               # Falso
		speed = speed * 1

