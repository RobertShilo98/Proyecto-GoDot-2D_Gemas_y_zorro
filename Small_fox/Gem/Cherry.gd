extends Area2D

#Función para desaparecer itemos/objetos coleccionables 
#o para puntaje.

func _ready():
	#Efecto de escalado X3
	$Tween.interpolate_property(
		$AnimatedSprite,
		'scale',
		$AnimatedSprite.scale,
		$AnimatedSprite.scale * 4,
		0.3,Tween.TRANS_QUAD,
		Tween.EASE_IN_OUT)
		
	#Efecto de desvanecimiento/opacidad (Canal Alpha).
	$Tween.interpolate_property(
		$AnimatedSprite,
		'modulate',
		Color(1, 1, 1, 1),
		Color(1, 1, 1, 0),
		0.3,Tween.TRANS_QUAD,
		Tween.EASE_IN_OUT)
	
func pickup():
	$Tween.start()
	yield($Tween, "tween_completed")
	call_deferred("queue_free")


func _on_LifeTimer_timeout():
	call_deferred("queue_free")

