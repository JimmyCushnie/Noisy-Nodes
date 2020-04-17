# Noisy Nodes
Adds various noise-generation nodes to Unity Shader Graph, including 3D noise nodes.

* Perlin noise 2D
* Perlin noise 2D periodic
* Perlin noise 3D
* Periodic noise 3D periodic
* Simplex noise 2D
* Simplex noise 2D gradient
* Simplex noise 3D
* Simplex noise 3D gradient

![demo.jpg](demo.jpg)

All of the fancy parts of this library come from [Noise Shader](https://github.com/keijiro/NoiseShader) by  keijiro. I just made shader graph nodes to call the functions.

Please note: I am very stupid, and I do not understand mathematical noise. It is likely that several nodes and node parameters have names which do not accurately reflect their function.

## Installation

Download the whole repo and stick it in your project's `Assets` folder.

Alternatively, Noisy Nodes can be installed via the Unity Package Manager. In the top left of the `Packages` window, navigate to `Add Package -> Add package from git URL` and paste `https://github.com/JimmyCushnie/Noisy-Nodes.git`.