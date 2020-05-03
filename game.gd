extends Control

export (PackedScene) var playerScene
export (int) var playerCount

var colorNames = ["gray","aqua","aquamarine","beige","bisque","blueviolet","burlywood","cadetblue","chartreuse","azure","brown","blue","chocolate","aliceblue","black","antiquewhite","blanchedalmond","firebrick","cornflower","darkred","floralwhite","forestgreen","fuchsia","crimson","darkblue","gainsboro","ghostwhite","darkgoldenrod","goldenrod","green","darkviolet","gold","honeydew","darkslateblue","darkolivegreen","indigo","khaki","darkcyan","lavender","lavenderblush","ivory","lawngreen","coral","darkkhaki","hotpink","lemonchiffon","lightblue","lightcoral","deepskyblue","lightcyan","lightgoldenrod","dimgray","darkgreen","cornsilk","darkorange","darkseagreen","darkmagenta","darksalmon","deeppink","darkturquoise","greenyellow","indianred","darkgray","darkorchid","cyan","darkslategray","dodgerblue","powderblue","palevioletred","purple","magenta","rebeccapurple","red","lightsteelblue","royalblue","rosybrown","mediumvioletred","lightslategray","mediumorchid","lightyellow","mediumpurple","mediumspringgreen","mediumaquamarine","mediumblue","limegreen","midnightblue","mintcream","lime","mediumturquoise","palegreen","lightpink","orange","lightsalmon","lightskyblue","mediumslateblue","moccasin","navajowhite","oldlace","olive","navyblue","orangered","palegoldenrod","papayawhip","peru","pink","orchid","paleturquoise","lightgray","lightgreen","lightseagreen","linen","maroon","olivedrab","mediumseagreen","peachpuff","mistyrose","plum","sandybrown","seashell","springgreen","steelblue","teal","wheat","turquoise","whitesmoke","seagreen","skyblue","tan","thistle","transparent","salmon","silver","saddlebrown","snow","tomato","sienna","violet","yellow","slategray","slateblue", "yellowgreen"]

var bombStartDuration = 10
var bombDuration = 10
var bombHolderIndex = 0
var playing = true
var isHolding = false
var playerBombSize: Vector2
var scrollTopLeftMargin: Vector2
var playerTimes = Array()

onready var board = $MainMargin/Vertical/BoardMargin/board
onready var players = board.find_node("MarginContainer").find_node("players")
onready var bomb = board.find_node("MarginContainer").find_node("Bomb")
onready var endPanel = $EndPanel
onready var looseLabel = $EndPanel/MainVBox/Center/ScoreVBox/LooseLabel
onready var scoreboardColumnsContainer = $EndPanel/MainVBox/Center/ScoreVBox/ScoreboardColumnsContainer

func _ready():
	scrollTopLeftMargin = Vector2(players.get_parent().get_constant("margin_left"), board.find_node("MarginContainer").get_constant("margin_top"))
	_start_game()

func _start_game():
	randomize()
	endPanel.visible = false
	playerCount = $"/root/globals".numberOfPlayers
	
	bombStartDuration = 3 + rand_range(0, 4)
	bombDuration = bombStartDuration
	
	while colorNames.size() > playerCount:
		colorNames.remove(randi() % colorNames.size())
	
	playing = true
	for n in range(0, playerCount):
		var newPlayer = playerScene.instance()
		newPlayer.colorName = colorNames[n]
		players.add_child(newPlayer)
		playerTimes.push_back(0)
	
	playerBombSize = players.get_children()[0].bombSize
	
	_update_bomb_display()

func _end_game():
	playing = false
	endPanel.visible = true
	looseLabel.text = "%s looses" % colorNames[bombHolderIndex]
	bomb._explode()
	$ExplosionParticles.global_position = bomb.global_position
	$ExplosionParticles.emitting = true
	$IgniteSound.stop()
	$BassSound.stop()
	$ExplosionSound.play()
	$MainMargin/Vertical/holdButton.disabled = true
	$MainMargin/Vertical/holdButton.visible = false
	for i in range(0, playerCount):
		var pLabel = Label.new()
		pLabel.text = "%s: %.2f" % [colorNames[i], playerTimes[i]]
		scoreboardColumnsContainer.find_node("Column1" if i%2==0 else "Column2").add_child(pLabel) 

func _process(delta):
	if playing:
		if isHolding:
			bombDuration -= delta
			playerTimes[bombHolderIndex] += delta
			#print(bombDuration)
			
		if bombDuration <= 0:
			_end_game()

func _on_holdButton_button_down():
	if playing:
		isHolding = true

func _on_holdButton_button_up():
	if playing:
		isHolding = false
		bombHolderIndex = (bombHolderIndex + 1) % playerCount
		_update_bomb_display()

func _update_bomb_display():
	var playersControl = players
	for i in range(0, playersControl.get_child_count()):
		var player: Control = playersControl.get_child(i)
		player._set_bomb(i == bombHolderIndex)
		
		if (i == bombHolderIndex):
			bomb.position = player.rect_position + scrollTopLeftMargin + (playerBombSize / 2)
			#set scroll position to follow the current user
			var scrollSize = board.rect_size
			if board.scroll_vertical > player.rect_position.y + scrollTopLeftMargin.y:
				$BombTween.interpolate_property(board, "scroll_vertical", board.scroll_vertical, player.rect_position.y + scrollTopLeftMargin.y, 0.8, Tween.TRANS_QUAD, Tween.EASE_OUT)
				$BombTween.start()
			elif board.scroll_vertical < player.rect_position.y - scrollSize.y + player.rect_size.y + scrollTopLeftMargin.y:
				$BombTween.interpolate_property(board, "scroll_vertical", board.scroll_vertical, player.rect_position.y - scrollSize.y + player.rect_size.y + scrollTopLeftMargin.y, 0.4, Tween.TRANS_QUAD, Tween.EASE_OUT)
				$BombTween.start()
	
	#set bomb shake strength
	var progress = (bombStartDuration - bombDuration) / bombStartDuration
	bomb.progress = progress
	$BassSound.volume_db = (1 - progress) * -80


func _on_menuButton_pressed():
	var _error = get_tree().change_scene("res://menu.tscn")
