extends Sprite2D

var max_velocity := 2.0
var acc := Vector2.ZERO
var velocity := Vector2.ZERO
var prev_global_position : Vector2
var lines : Array[Line2D]

func _ready():
    new_line()

func handle_edges(p_size: Vector2):    
    if global_position.x < 0:
        global_position.x = p_size.x
        new_line()
    elif global_position.x > p_size.x:
        global_position.x = 0
        new_line()
    if global_position.y < 0:
        global_position.y = p_size.y
        new_line()
    elif global_position.y > p_size.y:
        global_position.y = 0
        new_line()

func follow(flow_field: FlowField2D):
    var force := flow_field.sample_vector(global_position)
    apply_force(force)

func apply_force(force: Vector2):
    acc += force

func update():
    velocity += acc
    velocity = velocity.limit_length(max_velocity)
    global_position += velocity
    acc = Vector2.ZERO

func plot_line():
    lines[-1].add_point(global_position)

func new_line():
    var current_line = Line2D.new()
    current_line.width = 0.1
    current_line.modulate = Color(0, 1, 0, 0.2)
    current_line.top_level = true
    lines.append(current_line)
    add_child(current_line)
    pass
