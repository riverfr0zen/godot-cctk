extends Node2D

const FREQ_INC := 0.01

@export var num_particles := 1000
@export var flow_field_size := Vector2(40, 30)
@export var ff_speed := 2
@export var ff_frequency := 0.05
@export var ff_normalize := false
@export var particle_size := 8.0
@export var particle_speed := 2.0
var flow_field : FlowField2D
@onready var particle_ps := preload("res://examples/flow_field_exploration/particle1.tscn") as PackedScene

func _ready() -> void:
    flow_field = FlowField2D.new(flow_field_size)
    flow_field.speed = ff_speed
    flow_field.frequency = ff_frequency
    flow_field.normalize = ff_normalize
    $FlowFieldHud.position_center()
    $FlowFieldHud.flow_field = flow_field
    generate_particles()

func _process(delta: float) -> void:
    flow_field.update(delta)
    $FlowFieldHud.update()
    var screen = get_viewport().get_visible_rect().size
    #var f_scale = screen / flow_field_size
    var f_scale = ceil(screen / flow_field.size)
    for p in get_tree().get_nodes_in_group("particles"):
        var dir := flow_field.sample_vector(p.global_position, f_scale)
        p.global_position += dir * particle_speed
        if p.global_position.x < 0:
            p.global_position.x = screen.x
        elif p.global_position.x > screen.x:
            p.global_position.x = 0
        if p.global_position.y < 0:
            p.global_position.y = screen.y
        elif p.global_position.y > screen.y:
            p.global_position.y = 0

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("common.toggle_hud"):
        $FlowFieldHud.visible = !$FlowFieldHud.visible
    if event.is_action_pressed("common.restart"):
        flow_field.reseed()
    if event.is_action_pressed("ui_up"):
        flow_field.frequency += FREQ_INC
        print("frequency: %s" % flow_field.frequency)
    if event.is_action_pressed("ui_down"):
        flow_field.frequency -= FREQ_INC
        print("frequency: %s" % flow_field.frequency)

func generate_particles():
    var screen = get_viewport().get_visible_rect().size
    for i in range(num_particles):
        var pobj = particle_ps.instantiate()
        pobj.scale = Vector2(particle_size, particle_size)
        pobj.global_position = Vector2(randf_range(0, screen.x), randf_range(0, screen.y))
        add_child(pobj)
        pobj.add_to_group("particles")
