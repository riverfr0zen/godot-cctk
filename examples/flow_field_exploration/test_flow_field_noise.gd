extends Node2D

var flow_field : FlowField2D

func _ready() -> void:
    # For this example, I'm setting the flow field size to half the size of the grid
    # so that we can test the scale parameter later during the `sample_noise` call.
    flow_field = FlowField2D.new($GridManager.grid_size / 2)
    $GridManager.position_center()
    $GridManager.hide_grid = true


func _process(delta: float) -> void:
    flow_field.update(delta)
    
    for y in range($GridManager.grid_size.y):
        for x in range($GridManager.grid_size.x):
            var cval = flow_field.sample_noise(Vector2(x, y), Vector2(2, 2))
            var cell = $GridManager.get_cell_at(y, x)
            cell.color = Color(cval, cval, cval)
