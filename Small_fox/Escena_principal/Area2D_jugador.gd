extends Area2D

# Signals / Señales.

signal picked
signal hurt

var velocidad = Vector2.ZERO
var speed = 350

func _ready():
	#Centrar la centana del juego en la pantalla, 
	#por medio del OS Windows.
	OS.center_window() 
	position = Vector2(100, 100)
	#Inducción del sistema de vectores para,
	#animaciones y sprites en movimiento.
	  
func _process(delta):
	get_input()
	position += velocidad * delta
	#Método o función para mover a los sprites, 
	#por medio del toque en las teclas o entrada de datos.
	#por el teclado. 
	
	# Creación de un márgen o padding.	
	position.x = clamp(position.x, 0, 480)
	position.y = clamp(position.y, 0, 720)
	
	#Animaciones del personaje.
	process_animation()

func get_input():
	velocidad = Vector2.ZERO
	
	if Input.is_action_pressed("ui_right"):
		velocidad.x += 1
	if Input.is_action_pressed("ui_left"):
		velocidad.x -=1
	if Input.is_action_pressed("ui_up"):
		velocidad.y -= 1
	if Input.is_action_pressed("ui_down"):
		velocidad.y += 1
	
	if velocidad.length() > 0:
		velocidad = velocidad.normalized() * (speed)
		#print(velocidad)

func process_animation():
	if velocidad.length() != 0:
		$AnimatedSprite.play("Correr")
		
		if velocidad.x < 0:
			$AnimatedSprite.flip_h = true
		if velocidad.x > 0:
			$AnimatedSprite.flip_h = false
	else:
		$AnimatedSprite.play("Quieto")


#Función para desaparecer itemos/objetos coleccionables 
#o para puntaje.
func _on_Area2D_jugador_area_entered(area):
	if area.is_in_group("Gem"):
		$gemAudio.play()
		emit_signal("picked", "Gem")
		
	elif area.is_in_group("cherry"):
		$gemAudio.play()   #reproducir audio del PowerUp
		emit_signal("picked", "cherry")
		
	if area.has_method("pickup"):
		area.pickup()


func game_over():
	set_process(false)
	$AnimatedSprite.animation = "Herido"
	

func _on_Area2D_jugador_body_entered(body):
	if body.is_in_group("enemy"):
		emit_signal("hurt")

