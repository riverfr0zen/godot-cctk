@tool
extends GridManager

var flow_field : FlowField2D:
    set(v):
        flow_field = v
        grid_size = v.size

func update() -> void:
    if !visible: return
    for y in range(grid_size.y):
        for x in range(grid_size.x):
            var angle_vec = flow_field.sample_vector(Vector2(x, y))
            var cell = get_cell_at(y, x)
            cell.rotation = angle_vec.angle()
