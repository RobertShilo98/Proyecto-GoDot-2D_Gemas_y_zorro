extends Node2D

const basic_level = 5
const bonus_time = 5

export (PackedScene) var Gem

var Cherry = preload("res://Gem/Cherry.tscn")
var level = 0
var screensize = Vector2.ZERO
var time_left = 0
var score = 0
var level_game = 0
onready var GameOverTimer = Timer.new()


func _ready():
	$froggy.visible = false
	randomize()
	OS.center_window()
	timer_settings()
	$Control_hud/GameOverLabel.visible = false
	time_left = 20
	$Control_hud.update_timer(time_left)
	screensize = get_viewport().get_visible_rect().size
	spawn_gems()
	set_cherry_timer()
	$froggy.visible = true
	level_game = level_game + 1
	
	
func timer_settings():
	GameOverTimer.wait_time = 3
	GameOverTimer.connect("timeout", self, "_onGameOverTimer_timeout")
	add_child(GameOverTimer)
	
	
func _onGameOverTimer_timeout():
	get_tree().change_scene("res://menu/menu.tscn")


func _process(delta):
	update_platform_position()
	if $GemContainer.get_child_count() == 0:
		level += 1
		time_left += bonus_time
		var Audio = AudioStreamPlayer.new()
		Audio.stream = load("res://Assets/audio/Level.wav")
		add_child(Audio)
		Audio.play()
		spawn_gems()
		level_game += 1
		$Control_hud.update_level(level_game)
	
	
func update_platform_position():
	$Plataforma.position.x = $froggy.position.x
	

func spawn_gems():	
	for index in range(basic_level + level):
		var Gema = Gem.instance()
		Gema.position = Vector2(rand_range(0, screensize.x), rand_range(0, screensize.y))
		$GemContainer.add_child(Gema)


func _on_Game_timer_timeout():
	time_left -= 1
	$Control_hud.update_timer(time_left)
	if time_left <= 0:
		game_over2()
	# Decrementar el tiempo del juego.
	
	
func _on_Node2D_picked(type):
	match type:
		"Gem":
			score += 1
			$Control_hud.update_score(score)
		"cherry":
			time_left += 4
			score -= 3
			$Control_hud.update_score(score)
			$Control_hud.update_timer(time_left)


func game_over2():
	$Game_timer.stop()
	var AudioOver = AudioStreamPlayer.new()
	AudioOver.stream = load("res://Assets/audio/Hit.wav")
	add_child(AudioOver)
	AudioOver.play()
	$Control_hud/GameOverLabel.visible = true
	$Node2D.game_over()
	GameOverTimer.start()
	
	
func set_cherry_timer():
	var AudioCherry = AudioStreamPlayer.new()
	AudioCherry.stream = load("res://Assets/audio/Powerup.wav")
	add_child(AudioCherry)
	AudioCherry.play()
	var intervalo = rand_range(5, 10)
	$Cherry_Timer.wait_time = intervalo
	$Cherry_Timer.start()


func _on_Cherry_Timer_timeout():
	# 1. Parar el timer.
	# 2. Iniciar la escena de él sprite Cherry.
	# 3. Integrar la escena cherry al juego (Escena principal).
	# 4. Reajustar el time_out del timer.
	$Cherry_Timer.stop()
	var cherry = Cherry.instance()
	cherry.position.x = rand_range(25, 460)
	cherry.position.y = rand_range(25, 700)
	$GemContainer.add_child(cherry)
	set_cherry_timer()
	

func _on_Node2D_hurt():
	game_over2()
