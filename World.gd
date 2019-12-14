extends Node2D

var isDrawing = false
var drawingTimer = 0
var pointerPositions
var screenSize

func _initializePointerPositions(pos):
	pointerPositions = [pos]
	pointerPositions.resize(2)

func _updateEndPosition(pos):
	pointerPositions[1] = pos

func _shiftPointerPositions():
	pointerPositions[0] = pointerPositions[1]
	pointerPositions[1] = null

func _arePointerPositionsValid():
	if not pointerPositions[0]:
		return false
	if pointerPositions[0] and not pointerPositions[1]:
		pointerPositions[1] = get_global_mouse_position()
	return true

func _ready():
	screenSize = get_viewport().get_visible_rect().size
	set_process(true)

func _createPath(start, end):
	var node = Node2D.new()
	var sb = StaticBody2D.new()
	var pc = CollisionPolygon2D.new()
	sb.add_child(pc)
	pc.polygon = PoolVector2Array([start, end, Vector2(end.x, screenSize.y), Vector2(start.x, screenSize.y)])
	
	var polygon2Ds = []
	var colors = [Color("#d1ff19"), Color('#c4ff4d'), Color('#91ff4d')]
	for i in range(colors.size()):
		var offset = Vector2(0, i * 40)
		var p = Polygon2D.new()
		p.polygon = PoolVector2Array([start + offset, end + offset, Vector2(end.x, screenSize.y), Vector2(start.x, screenSize.y)])
		p.color = colors[i]
		p.antialiased = true
		node.add_child(p)

	node.add_child(sb)
	return node

func _process(delta):
	if isDrawing:
		drawingTimer += delta
		if drawingTimer > 0.01:
			if _arePointerPositionsValid():
				var p = _createPath(pointerPositions[0], pointerPositions[1])
				get_tree().root.add_child(p)
				_shiftPointerPositions()
			drawingTimer = 0

func _input(event):
	match event.get_class():
		"InputEventMouseButton":
			if event.pressed:
				_initializePointerPositions(get_canvas_transform().xform_inv(event.position))
				isDrawing = true
			else:
				isDrawing = false
		"InputEventMouseMotion":
			if isDrawing:
				_updateEndPosition(get_canvas_transform().xform_inv(event.position))
		