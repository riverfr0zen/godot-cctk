extends Sprite2D


func handle_edges(p_size: Vector2):    
    if global_position.x < 0:
        global_position.x = p_size.x
    elif global_position.x > p_size.x:
        global_position.x = 0
    if global_position.y < 0:
        global_position.y = p_size.y
    elif global_position.y > p_size.y:
        global_position.y = 0
