extends Sprite2D

var max_velocity := 2.0
var acc := Vector2.ZERO
var velocity := Vector2.ZERO
var previous_global_position : Vector2

func _ready():
    update_previous()

func handle_edges(p_size: Vector2):    
    if global_position.x < 0:
        global_position.x = p_size.x
        update_previous()
    elif global_position.x > p_size.x:
        global_position.x = 0
        update_previous()
    if global_position.y < 0:
        global_position.y = p_size.y
        update_previous()
    elif global_position.y > p_size.y:
        global_position.y = 0
        update_previous()

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

func update_previous():
    previous_global_position = global_position
