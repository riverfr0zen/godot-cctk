extends Node2D

const INNER = 0
const OUTER = 1
const CLR_MAX = 1.5
const CLR_MIN = 0.2
const WIDTH_MIN = 1.0
const WIDTH_MAX = 10.0

@export var rect := Rect2(Vector2(0, 0), Vector2(300, 300))
@export var density := 30
@export var inhibitors : Array[Vector2] = [Vector2(200, 300), Vector2(0, 150)]
@export var inhibitor_range := 100.0
@export var main_color := Color.RED
@export var second_color := Color.ORANGE
@export var third_color := Color.VIOLET
## Lower it (e.g., 0.5) for weaker inhibitors
@export var shortening_mod := 1.0
var spokes : Array[Line2D]
var spokes_mem : Array[Vector2]


func _ready() -> void:
    draw_spokes()

func _process(_delta: float) -> void:
    update_spokes_len()

func choose_color() -> Color:
    var chosen : Color
    var choice = randi_range(0, 10)
    if choice >= 0 and choice < 8:
        chosen = main_color
    elif choice >= 8 and choice < 10:
        chosen = second_color
    else:
        chosen = third_color
    var intensity_mod = randf_range(CLR_MIN, CLR_MAX)
    return chosen * Color(intensity_mod, intensity_mod, intensity_mod, 1.0)

func draw_spokes() -> void:
    for spoke in spokes:
        spoke.queue_free()
    spokes = []
    spokes_mem = []
    var origin = rect.get_center()
    var inner_circle = get_circle_points(origin, density, 50)
    #var inner_circle = get_circle_points(origin, 30, 50, 1.0, 1.5)
    #var outer_circle = get_circle_points(origin, 30, rect.size.y * 0.5)
    var outer_circle = get_circle_points(origin, density, rect.size.y * 0.5, 0.9, 1.0)
    #var outer_circle = get_circle_points(origin, 30, rect.size.y * 0.5, 0.4, 1.0)
    for pos in range(inner_circle.size()):
        var spoke = Line2D.new()
        spoke.default_color = choose_color()
        spoke.width = randf_range(WIDTH_MIN, WIDTH_MAX)
        spoke.add_point(inner_circle[pos])
        spoke.add_point(outer_circle[pos])
        spokes.append(spoke)
        spokes_mem.append(outer_circle[pos])
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

func update_spokes_len() -> void:
    var local_inhibitors: Array[Vector2] = []
    for global_pos in inhibitors:
        local_inhibitors.append(to_local(global_pos))

    for spoke_point_i in range(spokes_mem.size()):
        var nearest_inhibitor_distance := -1.0
        #print(spoke_point)
        for inhibitor in local_inhibitors:
            var distance = spokes_mem[spoke_point_i].distance_to(inhibitor)
            if nearest_inhibitor_distance < 0 or distance < nearest_inhibitor_distance:
                nearest_inhibitor_distance = distance
        if nearest_inhibitor_distance <= inhibitor_range and nearest_inhibitor_distance >= 0:
            var center_point = spokes[spoke_point_i].points[INNER]
            var curr_spoke_len = center_point.distance_to(spokes_mem[spoke_point_i])
            
            # Map the distance to a 0.0 -> 1.0 push factor.
            # If inhibitor is right on top (0), push_factor is 1.0 (max shrinkage).
            # If inhibitor is at the edge of range, push_factor is 0.0 (no shrinkage).
            var push_factor = remap(nearest_inhibitor_distance, 0.0, inhibitor_range, 1.0, 0.0)
            
            # Decide the maximum amount a spoke can possibly shrink (e.g., its full length, or a set max)
            var max_shrink_amount = curr_spoke_len 
            
            # Calculate new length and safely clamp it between 0 and the original length
            var reduction = max_shrink_amount * push_factor * shortening_mod
            var new_spoke_len = clampf(curr_spoke_len - reduction, 0.0, curr_spoke_len)
            
            # Update the line point
            var direction = center_point.direction_to(spokes_mem[spoke_point_i])
            spokes[spoke_point_i].set_point_position(OUTER, center_point + (direction * new_spoke_len))

func reset_spokes() -> void:
    for spoke_i in range(spokes.size()):
        spokes[spoke_i].set_point_position(OUTER, spokes_mem[spoke_i])
