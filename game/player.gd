extends Control

func _set_bomb(hasBomb):
	if hasBomb:
		$Label.text = "BOMB"
	else:
		$Label.text = ""
