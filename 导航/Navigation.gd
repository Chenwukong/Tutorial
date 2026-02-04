extends Node
class_name NavigationWheel

static func chase(node, target) -> void:
	if not target:
		return
	
	var agent: NavigationAgent2D = node.agent
	
	agent.target_position = target.global_position

	var next_pos: Vector2 = agent.get_next_path_position()
	
	if node.global_position.distance_to(next_pos) < 1.0:
		node.velocity = Vector2.ZERO
		return
	
	
	var dir: Vector2 = node.global_position.direction_to(next_pos)
	node.velocity = dir * node.speed
	
