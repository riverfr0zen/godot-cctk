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
# If you increase curl_tightness to 2.0, the target angle range becomes 0.0 to 2 * TAU (i.e. 720  degrees). 
# This forces the vector to spin through two full rotations over the exact same spatial noise distance. 
# Visually, this should make the flowing lines twist, spiral, and curl into much tighter, more chaotic whirlpools.
var curl_tightness := 1.0
var normalize := true
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
        normalize # setting normalize to true can result in more pronounced shifts
    )
    img = slices[0]

func sample_noise(local_position: Vector2, scale := Vector2(1, 1)) -> float:
    var scale_pos = local_position / scale
    return img.get_pixel(int(scale_pos.x), int(scale_pos.y)).r

func sample_vector(local_position: Vector2, scale := Vector2(1, 1)) -> Vector2:
    var scale_pos = local_position / scale
    var cval = img.get_pixel(int(scale_pos.x), int(scale_pos.y)).r
    # Remap the color value to 0 -> 360 (TAU), modified by curl_tightness
    var angle: float = remap(cval, 0.0, 1.0, 0.0, TAU * curl_tightness)
    return Vector2.from_angle(angle)
