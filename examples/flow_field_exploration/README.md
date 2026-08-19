# Flow field exploration notes

The notes describe the examples in this folder and how they fit into the exploration. All of these examples are based on the following videos from [The Coding Train](https://thecodingtrain.com/)

* [Perlin Noise in Two Dimensions (p5.js)](https://thecodingtrain.com/tracks/noise/noc/perlin/perlin-noise-2d)
* [Perlin Noise Flow Field](https://thecodingtrain.com/challenges/24-perlin-noise-flow-field)


Caveats / disclaimers:

* While flow fields in Godot are typically used for steering game objects, this is an exploration of flow fields used for creative coding. There are similarities, but expect differences owing to purpose.

* The flow field and particles implementations here run on the CPU. I decided to do it this way to stay closer to the exploration material from Processing/p5.js examples, and to simplify ease of use for users when creating sketches. It's possible to optimize by using the GPU if higher performance is needed, but I didn't want to complicate the exploration. I may add GPU accelerated versions or alternatives in the future. Feel free to contribute!


# test_noise_map.tscn

First exploration while looking at these videos:


This is scene is just exploring how to use Godot's noise functions and displays a noise map over a grid.

Different ways to get and animate the noise are explored.


# test_flow_field_noise.tscn


Before getting into flow field vectors, this example demonstrates getting noise from FlowField2D, recreating a grid-spaced noise map similar to [test_noise_map.tscn](#test_noise_maptscn) above.


# test_flow_field_hud.tscn


This first use of the FlowField2D class demonstrates using it in conjunction with FlowFieldHud to visualize the field's vectors.

You can press "R" to reseed the flow field.


# test_flow_field_particles.tscn


Demonstrates adding particles that move within the flow field. This follows fairly closely what was done in Daniel Schiffman's [Perlin Noise Flow Field](https://thecodingtrain.com/challenges/24-perlin-noise-flow-field) challenge video, but adapted for Godot tooling.

* Particles follow the flow field

* A ParticleTrails scene draws lines between particle positions. This scene or "visualizer" lives in a Subviewport that does not clear, so that it can persist the lines in a performant manner 

* Real-time controls
    * Reseed the flow field (toggle with "r")
    * Raise / lower the flow field frequency ("up" and "down" arrows)
    * Flow field HUD (toggle with "h")