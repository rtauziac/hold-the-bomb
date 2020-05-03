extends Control

export (bool) var hasBomb = false
var bombSize setget ,_get_bomb_size
var colorName setget _set_color_name

func _set_color_name(colorName):
	$HBoxContainer/bg.self_modulate = ColorN(colorName, 1)
	$HBoxContainer/MarginContainer/Label.text = colorName

func _get_bomb_size():
	return $HBoxContainer/BombSlot.rect_size

func _set_bomb(hasBomb):
	self.hasBomb = hasBomb
	#if hasBomb:
	#	$HBoxContainer/MarginContainer/Label.text = "BOMB"
	#else:
	#	$HBoxContainer/MarginContainer/Label.text = ""
