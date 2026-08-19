extends Node2D

@export var trail_color := Color("872f4233")
@export var trail_width := 1.0

func _process(_delta: float) -> void:
    queue_redraw()
    
func _draw() -> void:
    for p in get_tree().get_nodes_in_group("particles"):
        draw_line(to_local(p.previous_global_position), to_local(p.global_position), trail_color, trail_width)
        p.update_previous()
