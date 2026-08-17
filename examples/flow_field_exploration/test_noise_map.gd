extends Node2D

@export var animate := true
@export var cell_alpha := 0.5
@export var noise_freq := 0.1
@export_enum("noise_offset", "noise_3d", "get_image", "get_image3d") var noise_method := "get_image3d" 

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

    if noise_method == "noise_3d" || noise_method == "noise_offset":
        for y in range($GridManager.grid_size.y):
            for x in range($GridManager.grid_size.x):
                var cell = $GridManager.get_cell_at(y, x)
                #var r = noise.get_noise_2d(float(x), float(y))
                var r: float
                if noise_method == "noise_3d":
                    r = noise.get_noise_3d(float(x), float(y), time)
                if noise_method == "noise_offset":
                    r = noise.get_noise_2d(float(x) + time, float(y) + time)
                var cval = remap(r, -1.0, 1.0, 0.0, 1.0)
                cell.color = Color(cval, cval, cval, cell_alpha)            


    if noise_method == "get_image":
        noise.offset = Vector3(time, time, 0.0)
        var img: Image = noise.get_image($GridManager.grid_size.x, $GridManager.grid_size.y)
        for y in range($GridManager.grid_size.y):
            for x in range($GridManager.grid_size.x):
                var cval = img.get_pixel(x, y).r
                var cell = $GridManager.get_cell_at(y, x)
                cell.color = Color(cval, cval, cval, cell_alpha)

    if noise_method == "get_image3d":
        noise.offset = Vector3(0, 0, time)
        var slices: Array[Image] = noise.get_image_3d(
            $GridManager.grid_size.x, 
            $GridManager.grid_size.y, 
            1, # depth (we only need 1 slice for time)
            false, 
            true # setting normalize to true can result in darker areas
        )
        var img: Image = slices[0]
        #var img: Image = noise.get_image($GridManager.grid_size.x, $GridManager.grid_size.y)
        for y in range($GridManager.grid_size.y):
            for x in range($GridManager.grid_size.x):
                var cval = img.get_pixel(x, y).r
                var cell = $GridManager.get_cell_at(y, x)
                cell.color = Color(cval, cval, cval, cell_alpha)

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("common.toggle_hud"):
        $GridManager.hide_grid = !$GridManager.hide_grid
