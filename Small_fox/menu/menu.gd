extends Control

func _ready():
	OS.center_window()
	


func _on_boton_de_inicio_pressed():
	get_tree().change_scene("res://Main/Main.tscn")
