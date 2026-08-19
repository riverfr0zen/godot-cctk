(Work in progress)

A creative coding toolkit for Godot


# Set up

The set up is a little involved right now. I hope to simplify it in the future

1. Clone this repository

2. Clone [my fork of the grid-display addon](https://github.com/riverfr0zen/grid-display)

2. Copy or link the `grid-display/addons/grid_display` folder to `/addons/` in the godot-cctk repo

4. Open the godot-cctk project in Godot, go to *Project > Project Settings > Plugins* and enable the Grid Display plugin

You should now be set up to run the examples.


# Examples

Examples are in their respective category subfolders under [examples](examples). Each example is a scene (`.tscn` file) whose name starts with `test_` (e.g. `test_circle_spokes.tscn`). Some categories may have more than one example available.

You can run an example by:

* Opening the project in the Godot editor, opening the example scene, and clicking *Run Current Scene*

* -OR- directly in a terminal with the godot command, passing the scene as a parameter, e.g.:
    * `godot examples/circle_spokes/test_circle_spokes.tscn`



