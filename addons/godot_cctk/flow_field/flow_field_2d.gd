class_name FlowField2D
extends RefCounted

## The scale should be set against the main sketch size to simplify calls to `sample_vector`
## or `sample_noise` for MOST callers.
##
## It can be overridden in those methods as necessary (for e.g. FlowFieldHud forces a `Vector2.ONE`
## scale since it wants to draw the grid one to one with the flow field size).
var scale: Vector2 = Vector2.ONE
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
    noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
    #noise.noise_type = FastNoiseLite.TYPE_PERLIN
    noise.frequency = frequency
    reseed()
    update(0.0)

func set_scale_for_size(p_size: Vector2):
    scale = ceil(p_size / size)

func reseed():
    noise.seed = randi()    

func update(delta: float):
    time += delta * speed
    noise.offset = Vector3(0, 0, time)
    var slices: Array[Image] = noise.get_image_3d(
        ceil(size.x),
        ceil(size.y),
        1, # depth (we only need 1 slice for time)
        false, 
        normalize # setting normalize to true can result in more pronounced shifts
    )
    img = slices[0]

func sample_noise(local_position: Vector2, p_scale := scale) -> float:
    var scale_pos = local_position / p_scale
    # Clamp pixel coordinates to safe bounds [0, size - 1]
    var xpos := clampi(int(scale_pos.x), 0, img.get_width() - 1)
    var ypos := clampi(int(scale_pos.y), 0, img.get_height() - 1)
    return img.get_pixel(xpos, ypos).r

func sample_vector(local_position: Vector2, p_scale := scale) -> Vector2:
    var cval = sample_noise(local_position, p_scale)
    # Remap the color value to 0 -> 360 (TAU), modified by curl_tightness
    var angle: float = remap(cval, 0.0, 1.0, 0.0, TAU * curl_tightness)
    return Vector2.from_angle(angle)
