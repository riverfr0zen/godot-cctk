extends Sprite2D

var speed := 0.0

func handle_edges(p_size: Vector2):    
    if global_position.x < 0:
        global_position.x = p_size.x
    elif global_position.x > p_size.x:
        global_position.x = 0
    if global_position.y < 0:
        global_position.y = p_size.y
    elif global_position.y > p_size.y:
        global_position.y = 0

func follow(flow_field: FlowField2D):
    var dir := flow_field.sample_vector(global_position)
    global_position += dir * speed
