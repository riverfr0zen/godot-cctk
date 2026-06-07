extends Node2D

@export var rect := Rect2(Vector2(0, 0), Vector2(300, 300))


func _ready() -> void:
    var origin = rect.get_center()
    var inner_circle = get_circle_points(origin, 20, 50)
    #var outer_circle = get_circle_points(origin, 20, rect.size.y * 0.5)
    var outer_circle = get_circle_points(origin, 20, rect.size.y * 0.5, 0.8, 1.0)
    for pos in range(inner_circle.size()):
        var spoke = Line2D.new()
        spoke.default_color = Color.RED
        spoke.add_point(inner_circle[pos])
        spoke.add_point(outer_circle[pos])
        add_child(spoke)


func get_circle_points(origin: Vector2, count: int, rad: float, rad_mod_low := 1.0, rad_mod_high := 1.0) -> Array[Vector2]:
    var result: Array[Vector2] = []
    
    for i in range(count):
        # Calculate angle in radians (TAU is 2 * PI, representing a full circle)
        var angle = (i * TAU) / count

        # 1. Calculate the point offset from center
        var offset = Vector2(cos(angle), sin(angle)) * rad * randf_range(rad_mod_low, rad_mod_high)

        # 2. Add the origin to shift the point to the right place
        var point_position = origin + offset
        result.append(point_position)
    return result
