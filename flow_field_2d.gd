class_name FlowField2D
extends RefCounted

var size: Vector2
var noise : FastNoiseLite
var time := 0.0
var speed := 10.0
# Default frequency is 0.01. Bumping it up creates more dramatic shifts per pixel.
# Try values between 0.05 and 0.2
var frequency := 0.1:
    set(v):
        frequency = v
        if noise: noise.frequency =  v
var img : Image

func _init(p_size: Vector2):
    size = p_size
    noise = FastNoiseLite.new()
    noise.noise_type = FastNoiseLite.TYPE_PERLIN
    noise.seed = randi()
    noise.frequency = frequency
    update(0.0)

func update(delta: float):
    time += delta * speed
    noise.offset = Vector3(0, 0, time)
    var slices: Array[Image] = noise.get_image_3d(
        int(size.x),
        int(size.y),
        1, # depth (we only need 1 slice for time)
        false, 
        true # setting normalize to true can result in darker areas
    )
    img = slices[0]

func sample_noise(local_position: Vector2, scale := Vector2(1, 1)) -> float:
    var scale_pos = local_position / scale
    return img.get_pixel(int(scale_pos.x), int(scale_pos.y)).r
