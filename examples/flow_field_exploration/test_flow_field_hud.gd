extends Node2D

var flow_field : FlowField2D

func _ready() -> void:
    # For this example, I'm setting the flow field size to half the size of the grid
    # so that we can test the scale parameter later during the `sample_vector` call.
    flow_field = FlowField2D.new($GridManager.grid_size / 2)
    flow_field.speed = 2
    flow_field.frequency = 0.05
    #flow_field.normalize = false
    $GridManager.position_center()
    $GridManager.hide_grid = true


func _process(delta: float) -> void:
    flow_field.update(delta)
    
    for y in range($GridManager.grid_size.y):
        for x in range($GridManager.grid_size.x):
            var angle_vec = flow_field.sample_vector(Vector2(x, y), Vector2(2, 2))
            var cell = $GridManager.get_cell_at(x, y)
            cell.rotation = angle_vec.angle()

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("common.restart"):
        flow_field.reseed()
