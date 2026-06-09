extends Node

@export var max_inhibitors := 10
@export var inhibitor_range_min := 100.0
@export var inhibitor_range_max := 200.0
var inhibitors : Array[Vector2] = [Vector2(400, 150), Vector2(500, 500), Vector2(800, 400)]
var inhibitors_mv : Array[Vector2]

func _ready() -> void:
    #RenderingServer.set_default_clear_color(Color.WEB_GRAY)

    # Center the grid
    $GridManager.global_position = get_viewport().get_visible_rect().size * 0.5 - ($GridManager.size / 2)
    reinit()

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("common.restart"):
        reinit()

func _process(_delta: float) -> void:
    for i in range(inhibitors.size()):
        if !$GridManager.display.rect.has_point($GridManager.display.to_local(inhibitors[i])):
            inhibitors_mv[i] = Vector2(-inhibitors_mv[i].x, -inhibitors_mv[i].y)           
        inhibitors[i] = inhibitors[i] + inhibitors_mv[i]

func get_random_direction() -> Vector2:
    var dir := Vector2.from_angle(randf() * TAU)
    dir = dir * Vector2(randf_range(0.1, 5.0), randf_range(0.1, 5.0))
    return dir

func reinit() -> void:
    for sketch in $GridManager.cell_nodes:
        #sketch.draw_spokes()
        sketch.reset_spokes()
    
    var inhibitor_range = randf_range(inhibitor_range_min, inhibitor_range_max)
    print("Inhibitor range: ", inhibitor_range)
    $GridManager.set_cells_prop("inhibitor_range", inhibitor_range)
    inhibitors = []
    inhibitors_mv = []
    for i in range(max_inhibitors):
        if randi_range(0, 1) == 1:
            inhibitors.append(Vector2(
                randf_range($GridManager.position.x, $GridManager.position.x + $GridManager.size.x),
                randf_range($GridManager.position.y, $GridManager.position.y + $GridManager.size.y)
            ))
            inhibitors_mv.append(get_random_direction())
    print("Inhibitors: ", inhibitors.size())
    
    for sketch in $GridManager.cell_nodes:
        sketch.inhibitors = inhibitors
