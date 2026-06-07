extends Node

func _ready() -> void:
    # Center the grid
    $GridManager.global_position = get_viewport().get_visible_rect().size * 0.5 - ($GridManager.size / 2)
