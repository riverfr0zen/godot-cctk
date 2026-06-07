@tool
class_name GridManager
extends Node2D


@export var size := Vector2(800, 600):
    set(value):
        size = value
        update_display_size()
@export var grid_size := Vector2(8, 6):
    set(value):
        grid_size = value
        update_display_size()
@export var alpha := 1.0:
    set(value): 
        alpha = value
        update_display_alpha()
@export var line_size := 1.0:
    set(value): 
        line_size = value
        update_display_line_sizes()
@export var cell_scene : PackedScene
## Hides the grid *in game only*. Will still display in editor.
@export var hide_grid := false

var display : GridDisplay
var cell_nodes := []

func _ready() -> void:
    display = GridDisplay.new()
    display.grid_size = Vector2(10, 10)
    display.cell_size = Vector2(10, 10)
    add_child(display)
    update_display_line_sizes()
    update_display_alpha()
    update_display_size()

    if cell_scene:
        #print(cell_scene.resource_path)
        for j in range(int(grid_size.y)):
            for i in range(int(grid_size.x)):
                var cell_scene_inst = cell_scene.instantiate()
                cell_scene_inst.position = get_cell_local_pos(Vector2i(i, j))
                cell_scene_inst.scale =  display.cell_size / cell_scene_inst.rect.size
                add_child(cell_scene_inst)
                cell_nodes.append(cell_scene_inst)

    if hide_grid and not Engine.is_editor_hint():
        display.hide()

func update_display_size():
    if display:
        display.grid_size = grid_size
        display.cell_size = size / grid_size
    
func update_display_line_sizes():
    if display:
        display.line_size = Vector2(line_size, line_size)
        display.border_width = line_size
        display.queue_redraw()

func update_display_alpha():
    if display:
        display.hline_color.a = alpha
        display.vline_color.a = alpha
        display.border_color.a = alpha
        display.queue_redraw()

func get_cell_grid_pos(local_pos: Vector2) -> Vector2i:
    # .floor() ensures -0.1 becomes -1 (instead of 0), -1.1 becomes -2, etc.
    return Vector2i((local_pos / display.cell_size).floor())

func get_cell_local_pos(grid_pos: Vector2i) -> Vector2:
    return Vector2(grid_pos) * display.cell_size

func get_cell_center(pos: Vector2) -> Vector2:
    return Vector2(pos.x + display.cell_size.x * 0.5, pos.y + display.cell_size.y * 0.5)

func display_has_point(cell_grid_pos: Vector2i) -> bool:
    return Rect2(Vector2.ZERO, display.grid_size).has_point(cell_grid_pos)
