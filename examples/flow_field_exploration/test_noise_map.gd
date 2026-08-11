extends Node3D

@export var cell_alpha := 0.5
@export var noise_freq := 0.1

var noise : FastNoiseLite


func _ready() -> void:
    noise = FastNoiseLite.new()
    noise.noise_type = FastNoiseLite.TYPE_PERLIN
    noise.seed = randi()
    # Default frequency is 0.01. Bumping it up creates more dramatic shifts per pixel.
    # Try values between 0.05 and 0.2
    noise.frequency = noise_freq

    # Center the grid
    $GridManager.position_center()
    
func _process(_delta: float) -> void:
    for y in range($GridManager.grid_size.y):
        for x in range($GridManager.grid_size.x):
            var cell = $GridManager.get_cell_at(x, y)
            var r = noise.get_noise_2d(float(x), float(y))
            var cval = remap(r, -1.0, 1.0, 0.0, 1.0)
            cell.color = Color(cval, cval, cval, cell_alpha)            
