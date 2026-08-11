extends Node3D

@export var animate := true
@export var cell_alpha := 0.5
@export var noise_freq := 0.1
@export_enum("noise_3d", "noise_offset") var noise_method := "noise_3d" 

var noise : FastNoiseLite
var time := 0.0
var speed := 10.0

func _ready() -> void:
    noise = FastNoiseLite.new()
    noise.noise_type = FastNoiseLite.TYPE_PERLIN
    noise.seed = randi()
    # Default frequency is 0.01. Bumping it up creates more dramatic shifts per pixel.
    # Try values between 0.05 and 0.2
    noise.frequency = noise_freq

    # Center the grid
    $GridManager.position_center()
    
func _process(delta: float) -> void:
    if animate:
        time += delta * speed

    for y in range($GridManager.grid_size.y):
        for x in range($GridManager.grid_size.x):
            var cell = $GridManager.get_cell_at(x, y)
            #var r = noise.get_noise_2d(float(x), float(y))
            var r: float
            if noise_method == "noise_3d":
                r = noise.get_noise_3d(float(x), float(y), time)
            if noise_method == "noise_offset":
                r = noise.get_noise_2d(float(x) + time, float(y) + time)
            var cval = remap(r, -1.0, 1.0, 0.0, 1.0)
            cell.color = Color(cval, cval, cval, cell_alpha)            
