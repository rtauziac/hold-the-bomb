extends Control

func _set_bomb(hasBomb):
	if hasBomb:
		$HBoxContainer/MarginContainer/Label.text = "BOMB"
	else:
		$HBoxContainer/MarginContainer/Label.text = ""
