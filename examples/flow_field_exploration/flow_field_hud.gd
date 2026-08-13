@tool
extends GridManager

var flow_field : FlowField2D:
    set(v):
        flow_field = v
        grid_size = v.size

func update() -> void:
    for y in range(grid_size.y):
        for x in range(grid_size.x):
            var angle_vec = flow_field.sample_vector(Vector2(x, y), Vector2(2, 2))
            var cell = get_cell_at(x, y)
            cell.rotation = angle_vec.angle()
