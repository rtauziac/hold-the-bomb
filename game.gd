extends Control

export (PackedScene) var playerScene
export (int) var playerCount

var bombDuration = 100
var bombHolderIndex = 0
var playing = true
var isHolding = false

func _ready():
	_start_game()

func _start_game():
	randomize()
	playerCount = $"/root/globals".numberOfPlayers
	
	bombDuration = 5 + rand_range(0, 15)
	
	playing = true
	for n in range(0, playerCount):
		var newPlayer = playerScene.instance()
		$"board/MarginContainer/players".add_child(newPlayer)
	
	_update_bomb_display()

func _process(delta):
	if playing:
		if isHolding:
			bombDuration -= delta
			#print(bombDuration)
			
		if bombDuration <= 0:
			#print("BOOM! Player %d looses" % bombHolderIndex)
			$Label.visible = true
			$Label.text = "BOOM! Player %d looses" % (bombHolderIndex + 1)
			playing = false

func _on_holdButton_button_down():
	if playing:
		isHolding = true

func _on_holdButton_button_up():
	if playing:
		isHolding = false
		bombHolderIndex = (bombHolderIndex + 1) % playerCount
		_update_bomb_display()

func _update_bomb_display():
	var playersControl = $board/MarginContainer/players
	for i in range(0, playersControl.get_child_count()):
		var player = playersControl.get_child(i)
		player._set_bomb(i == bombHolderIndex)

func _on_menuButton_pressed():
	get_tree().change_scene("res://menu.tscn")
