extends Node2D

const FREQ_INC := 0.01

var flow_field : FlowField2D

func _ready() -> void:
    flow_field = FlowField2D.new(Vector2(40, 30))
    flow_field.speed = 2
    flow_field.frequency = 0.05
    #flow_field.normalize = false
    $FlowFieldHud.position_center()
    # Setting the flow_field on the hud will also update the hud's grid size
    $FlowFieldHud.flow_field = flow_field

func _process(delta: float) -> void:
    flow_field.update(delta)
    $FlowFieldHud.update()

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("common.restart"):
        flow_field.reseed()
    if event.is_action_pressed("ui_up"):
        flow_field.frequency += FREQ_INC
        print("frequency: %s" % flow_field.frequency)
    if event.is_action_pressed("ui_down"):
        flow_field.frequency -= FREQ_INC
        print("frequency: %s" % flow_field.frequency)
