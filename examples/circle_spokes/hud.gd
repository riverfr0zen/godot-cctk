extends Node2D


func _draw() -> void:
    for inhibitor in get_parent().points_field.positions:
        draw_circle(inhibitor, 5, Color.BLUE)
        pass

func _process(_delta: float) -> void:
    queue_redraw()
