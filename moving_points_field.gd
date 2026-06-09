class_name MovingPointsField
extends Node

var rect: Rect2
var positions: Array[Vector2]
var directions: Array[Vector2]


func _init(p_rect: Rect2) -> void:
    rect = p_rect


func get_random_direction() -> Vector2:
    var dir := Vector2.from_angle(randf() * TAU)
    dir = dir * Vector2(randf_range(0.1, 5.0), randf_range(0.1, 5.0))
    return dir

func gen_random(max: int) -> void:
    positions = []
    directions = []
    for i in range(max):
        if randi_range(0, 1) == 1:
            positions.append(Vector2(
                randf_range(rect.position.x, rect.position.x + rect.size.x),
                randf_range(rect.position.y, rect.position.y + rect.size.y)
            ))
            directions.append(get_random_direction())

# Moves points 1 step according to their directions, bouncing them if they hit a `rect` wall
func bounce_step(local_obj: Variant, rect: Rect2) -> void:
    for i in range(positions.size()):
        var local_pos = local_obj.to_local(positions[i])

        # x boundaries (left & right walls)
        if local_pos.x <= rect.position.x:
            # Snap to edge, then bounce x
            local_pos.x = rect.position.x                 
            directions[i].x = -directions[i].x
        elif local_pos.x >= rect.end.x:
            # Snap to edge, then bounce x
            local_pos.x = rect.end.x
            directions[i].x = -directions[i].x
        # y boundaries (top & bottom walls)
        if local_pos.y <= rect.position.y:
            # Snap to edge, then bounce y
            local_pos.y = rect.position.y
            directions[i].y = -directions[i].y
        elif local_pos.y >= rect.end.y:
            # Snap to edge, then bounce y
            local_pos.y = rect.end.y
            directions[i].y = -directions[i].y
        positions[i] = local_obj.to_global(local_pos)
        positions[i] = positions[i] + directions[i]
