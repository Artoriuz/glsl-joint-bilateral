# GLSL Joint Bilateral

## Overview
This is a simple implementation of joint bilateral chroma upsampling. It uses the luma plane as a guide to achieve sharper edges without introducing any ringing.

The repo contains 2 distinct shaders:
- `JointBilateral.glsl`: This is the ["classic version"](https://en.wikipedia.org/wiki/Bilateral_filter) of the shader with gaussian functions.
- `FastBilateral.glsl`: This uses bilinear interpolation in the spatial plane, which makes it pretty fast.

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
- `distance_coeff`: Controls the shape of the spatial Gaussian filter. Higher values decrease the contribution of pixels more distant to the centre. Accepts floats higher than `0.0`, defaults to `3.0`.
- `intensity_coeff`: Controls the shape of the Gaussian filter used for intensity-distance weighting. Higher values decrease the contribution of pixels with distant luminosities. Accepts floats higher than `0.0`, defaults to `128.0`.

On `vo=gpu-next`, you can set these settings with `--glsl-shader-opts=param1=value1,param2=value2,...`.

## Benchmarks
The following benchmarks were conducted with `--vo=gpu-next --gpu-api=vulkan` on a 6600XT. The test image can be found under `./benchmarks`. Since this is an actual illustration and not a video frame, the difference between the scalers is magnified. You can expect these numbers to be closer together on compressed video content. Please note that this comparison may not always be up to date.

| Filter         | MAE    | PSNR    | SSIM   | MS-SSIM | Frame Timing |
|----------------|--------|---------|--------|---------|--------------|
| krigbilateral  | 0.0025 | 41.1124 | 0.9941 |  0.9994 | 511 μs       |
| jointbilateral | 0.0027 | 40.2050 | 0.9928 |  0.9992 | 173 μs       |
| fastbilateral  | 0.0027 | 40.1569 | 0.9928 |  0.9991 | 68 μs        |
| lanczos        | 0.0031 | 39.3481 | 0.9915 |  0.9987 | 152 μs       |
| polar_lanczos  | 0.0032 | 39.1656 | 0.9911 |  0.9987 | 284 μs       |
| bilinear       | 0.0033 | 38.5826 | 0.9905 |  0.9986 | 0 μs         |

## Example
![JointBilateral Example](./example.png "JointBilateral Example")