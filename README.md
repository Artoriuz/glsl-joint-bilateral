# GLSL Joint Bilateral

## Overview
This is a simple implementation of joint bilateral chroma upsampling. It uses the luma plane as a guide to achieve sharper edges without introducing any ringing.
The repo contains 2 distinct shaders:
- `JointBilateral.glsl`: This is the ["classic" version](https://en.wikipedia.org/wiki/Bilateral_filter) of the shader with tunable parameters and gaussian filters.
- `FastBilateral.glsl`: This uses bilinear interpolation in the spatial plane and a much simpler pixel binning logic for intensity instead, which makes it pretty damn fast.

Both shaders are pretty much in alpha status, bugs and/or non-optimal parameters are to be expected. In their current states, I actually think `FastBilateral.glsl` is more likely to be working correctly.

## Instructions
Add something like this to your mpv config:
```
vo=gpu-next
glsl-shader="path/to/shader/FastBilateral.glsl"
```
gpu-next is required due to the usage of tunable parameters.

## Parameters
You can set the following parameters with `JointBilateral.glsl`:
- `length`: Controls the size of the spatial Gaussian filter. Accepts integers higher than `1`, defaults to `4`.
- `distance_coeff`: Controls the shape of the spatial Gaussian filter. Higher values decrese the contribution of pixels more distant to the centre. Accepts floats higher than `0.0`, defaults to `4.0`.
- `intensity_coeff`: Controls the shape of the Gaussian function used for intensity distances. Higher values decrese the contribution of pixels with distant luminosities. Accepts floats higher than `0.0`, defaults to `128.0`.

On `vo=gpu-next`, you can set these settings with `--glsl-shader-opts=param1=value1,param2=value2,...`.
