# GLSL Joint Bilateral

## Overview
This is a simple implementation of joint bilateral chroma upsampling. It uses the luma plane as a guide to achieve sharper edges without introducing any ringing.

The repo contains 2 distinct shaders:
- `JointBilateral.glsl`: This uses the coefficient of determination to mix the output of the joint-bilateral filter with the output of a (very) sharp spatial filter. You can turn it into the ["classic version"](https://en.wikipedia.org/wiki/Bilateral_filter) of what is known as "joint-bilateral" setting `#define USE_SHARP_SPATIAL_FILTER 0` (which will make the shader much blurrier and more likely to smear where the local correlation between luma and chroma is low). To understand how this works feel free to read ["this paper"](https://johanneskopf.de/publications/jbu/paper/FinalPaper_0185.pdf).
- `FastBilateral.glsl`: This is a simplified version of the shader. You should probably not use it as it's very hit or miss and usually worse than lanczos (mpv's default).

## Instructions
Add something like this to your mpv config:
```
vo=gpu-next
glsl-shader="path/to/shader/JointBilateral.glsl"
```
gpu-next is required due to the usage of tunable parameters.

## Parameters
You can set the following parameters:
- `distance_coeff`: Controls the shape of the spatial Gaussian filter. Higher values decrease the contribution of pixels more distant to the centre.
- `intensity_coeff`: Controls the shape of the Gaussian filter used for intensity-distance weighting. Higher values decrease the contribution of pixels with distant luminosities.

On `vo=gpu-next`, you can set these settings with `--glsl-shader-opts=param1=value1,param2=value2,...`.

## Example
This example has not been kept up to date, but it can illustrate what the shader does relatively well:
![JointBilateral Example](./example.png "JointBilateral Example")
