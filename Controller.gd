extends Node2D

onready var this = get_node('.')

var t = 0

func _process(delta):
	this.position = this.position.linear_interpolate(get_global_mouse_position(), 0.1)