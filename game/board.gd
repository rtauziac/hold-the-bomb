extends Control

export (Vector2) var itemSize = Vector2(10, 10)

func add_child(node, legible_unique_name = false):
	.add_child(node, legible_unique_name)
	#layout()

func layout():
	for i in range(0, get_child_count()):
		var child: Control = get_child(i)
		var origin = Vector2(itemSize.x * i, 0)
		child.margin_left = origin.x
		child.margin_top = origin.y
		child.margin_right = origin.x + itemSize.x
		child.margin_bottom = origin.y + itemSize.y

