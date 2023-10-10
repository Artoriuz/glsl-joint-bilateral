# GLSL Joint Bilateral

## Overview
This is a simple implementation of joint bilateral chroma upsampling. It uses the luma plane as a guide to achieve sharper edges without introducing any ringing.

The repo contains 2 distinct shaders:
- `JointBilateral.glsl`: This is the ["classic version"](https://en.wikipedia.org/wiki/Bilateral_filter) of the shader with gaussian functions.
- `MemeBilateral.glsl`: Attempts to fix the main shortcomings of JointBilateral by combining it with some logic from CfL. This uses the coefficient of determination to mix the output of the bilateral filter with the output of a (very) sharp spatial filter.
- `FastBilateral.glsl`: This is a simplified version of the shader.

## Instructions
Add something like this to your mpv config:
```
vo=gpu-next
# For the classic version:
glsl-shader="path/to/shader/JointBilateral.glsl"
# For the simpler/faster version:
glsl-shader="path/to/shader/FastBilateral.glsl"
```
gpu-next is required due to the usage of tunable parameters.

## Parameters
You can set the following parameters:
- `distance_coeff`: Controls the shape of the spatial Gaussian filter. Higher values decrease the contribution of pixels more distant to the centre.
- `intensity_coeff`: Controls the shape of the Gaussian filter used for intensity-distance weighting. Higher values decrease the contribution of pixels with distant luminosities.

On `vo=gpu-next`, you can set these settings with `--glsl-shader-opts=param1=value1,param2=value2,...`.

## Example
![JointBilateral Example](./example.png "JointBilateral Example")