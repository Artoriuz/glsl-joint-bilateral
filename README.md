# GLSL Joint Bilateral

## Overview
This is a simple implementation of joint bilateral chroma upsampling. It uses the luma plane as a guide to achieve sharper edges without introducing any ringing.

The repo currently contains a single shader:
- `FastBilateral.glsl`: This uses bilinear interpolation in the spatial plane and a much simpler pixel binning logic for intensity instead, which makes it pretty damn fast.

## Instructions
Add something like this to your mpv config:
```
vo=gpu-next
glsl-shader="path/to/shader/FastBilateral.glsl"
```
gpu-next is required due to the usage of tunable parameters.

## Parameters
You can set the following parameter:
- `intensity_coeff`: Controls the shape of the Gaussian filter used for intensity-distance weighting. Higher values decrease the contribution of pixels with distant luminosities. Accepts floats higher than `0.0`, defaults to `64.0`.

On `vo=gpu-next`, you can set these settings with `--glsl-shader-opts=param1=value1,param2=value2,...`.

## Example
![FastBilateral Example](./example.png "FastBilateral Example")