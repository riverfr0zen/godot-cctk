This is the first example created for godot-cctk and demonstrates using the [GridManager](/addons/godot-cctk/grid_manager.tscn) and [MovingPointsField](/addons/godot-cctk/moving_points_field.gd) utilities.

[CircleSpokes](circle_spokes.tscn) is a standalone Godot scene that features a few RNG variations and spokes that shrink from nearby "inhibitor points".

In the [example](test_circle_spokes.tscn), GridManager repeats instances of the scene, and the MovingPointsField generates and animates the inhibitor points across the grid space.

Controls:

* "h": Toggle HUD to display the grid and inhibitor points
* "r": Reset the sketch, re-instancing the circle spokes scenes and generating new inhibitor points