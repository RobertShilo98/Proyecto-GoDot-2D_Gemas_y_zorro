extends Control

func update_timer(new_val):
	$MarginContainer/Label_timer.text = str(new_val)
	
func update_score(new_val):
	$MarginContainer/Label_score.text = str(new_val)

func update_level(new_val):
	$MarginContainer/Label_level.text = str(new_val)

