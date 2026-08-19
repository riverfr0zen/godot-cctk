extends TextureRect

func _ready() -> void:
    # Since the grid will scale and position the arrow scene, we have to
    # nudge the position backward  to cancel out the translation jump from
    # pivot offset, and adjust based on the scale 
    position -= pivot_offset - (pivot_offset * scale)
