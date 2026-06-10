extends Node

@export var max_inhibitors := 10
@export var inhibitor_range_min := 100.0
@export var inhibitor_range_max := 200.0
@export var inhibitor_speed_min := 0.1
@export var inhibitor_speed_max := 5.0
var points_field : MovingPointsField

func _ready() -> void:
    #RenderingServer.set_default_clear_color(Color.WEB_GRAY)

    # Center the grid
    $GridManager.global_position = get_viewport().get_visible_rect().size * 0.5 - ($GridManager.size / 2)
    points_field = MovingPointsField.new($GridManager.display.rect)
    reinit()

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("common.restart"):
        reinit()
    if event.is_action_pressed("common.toggle_hud"):
        toggle_hud()

func _process(_delta: float) -> void:
    points_field.bounce_step($GridManager.display, $GridManager.display.rect)

func toggle_hud() -> void:
    if $Hud.visible:
        $Hud.hide()
    else:
        $Hud.show()
    $GridManager.hide_grid = !$GridManager.hide_grid

func reinit() -> void:
    for sketch in $GridManager.cell_nodes:
        sketch.draw_spokes()
        #sketch.reset_spokes()
    
    var inhibitor_range := randf_range(inhibitor_range_min, inhibitor_range_max)
    print("Inhibitor range: ", inhibitor_range)
    $GridManager.set_cells_prop("inhibitor_range", inhibitor_range)
    points_field.gen_random(max_inhibitors, inhibitor_speed_min, inhibitor_speed_max)
    print("Inhibitors: ", points_field.positions.size())
    
    for sketch in $GridManager.cell_nodes:
        sketch.inhibitors = points_field.positions
