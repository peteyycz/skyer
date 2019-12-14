extends RigidBody2D

func _physics_process(delta):
	var bodies = get_node("Area2D").get_overlapping_bodies()
	if bodies.size() > 1:
		set('linear_velocity', get('linear_velocity') + Vector2(10, 0))