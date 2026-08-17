# Exploration notes

These notes will indicate what each scene in this folder is, and how they fit into the exploration.


# test_noise_map.tscn

First exploration while looking at these videos:

* https://www.youtube.com/watch?v=na7LuZsW2UM
* https://www.youtube.com/watch?v=BjoM9oKOAKY

This is scene is just exploring how to use Godot's noise functions and displays a noise map over a grid.

Different ways to get and animate the noise are explored.


# test_flow_field_noise.tscn


Before getting into flow field vectors, this example demonstrates getting noise from FlowField2D, recreating a grid-spaced noise map similar to [test_noise_map.tscn](#test_noise_maptscn) above.


# test_flow_field_hud.tscn


This first use of the FlowField2D class demonstrates using it in conjunction with FlowFieldHud to visualize the field's vectors.

You can press "R" to reseed the flowfield.