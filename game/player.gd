extends Control

export (bool) var hasBomb = false
var bombSize setget ,_get_bomb_size
var colorName setget _set_color_name

func _set_color_name(colorName):
	var _color = ColorN(colorName, 1)
	$HBoxContainer/bg.self_modulate = _color 
	$HBoxContainer/MarginContainer/Label.text = colorName
	$HBoxContainer/MarginContainer/Label.set("custom_colors/font_outline_modulate", _color)
	var _perceptiveness = 0.3 * _color.r + 0.5 * _color.g + 0.2 * _color.b
	$HBoxContainer/MarginContainer/Label.set("custom_colors/font_color", Color.white if _perceptiveness < 0.4 else Color.black)

func _get_bomb_size():
	return $HBoxContainer/BombSlot.rect_size

func _set_bomb(hasBomb):
	self.hasBomb = hasBomb
	#if hasBomb:
	#	$HBoxContainer/MarginContainer/Label.text = "BOMB"
	#else:
	#	$HBoxContainer/MarginContainer/Label.text = ""
