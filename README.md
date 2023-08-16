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
| Shader/Filter  | MAE      | PSNR    | SSIM   | MS-SSIM |   | MAE (N) | PSNR (N) | SSIM (N) | MS-SSIM (N) |   | Mean   |
|----------------|----------|---------|--------|---------|---|---------|----------|----------|-------------|---|--------|
| cfl_4tap       | 9.41E-04 | 51.0104 | 0.9980 |  0.9996 |   |  1.0000 |   1.0000 |   1.0000 |      1.0000 |   | 1.0000 |
| cfl_mix        | 1.02E-03 | 50.8475 | 0.9979 |  0.9995 |   |  0.8443 |   0.9463 |   0.9026 |      0.9322 |   | 0.9063 |
| krigbilateral  | 1.03E-03 | 51.0087 | 0.9977 |  0.9996 |   |  0.8082 |   0.9994 |   0.7875 |      0.9910 |   | 0.8965 |
| cfl_12tap      | 1.06E-03 | 50.3955 | 0.9977 |  0.9995 |   |  0.7583 |   0.7974 |   0.7695 |      0.8469 |   | 0.7930 |
| cfl_16tap      | 1.12E-03 | 49.9846 | 0.9975 |  0.9995 |   |  0.6340 |   0.6621 |   0.6276 |      0.7333 |   | 0.6642 |
| fastbilateral  | 1.26E-03 | 49.2835 | 0.9972 |  0.9994 |   |  0.3308 |   0.4311 |   0.3426 |      0.5503 |   | 0.4137 |
| jointbilateral | 1.29E-03 | 49.1986 | 0.9971 |  0.9994 |   |  0.2563 |   0.4032 |   0.2450 |      0.5030 |   | 0.3519 |
| polar_lanczos  | 1.31E-03 | 48.6640 | 0.9971 |  0.9991 |   |  0.2173 |   0.2270 |   0.2970 |      0.0000 |   | 0.1853 |
| lanczos        | 1.34E-03 | 48.6891 | 0.9971 |  0.9992 |   |  0.1646 |   0.2353 |   0.2640 |      0.0062 |   | 0.1675 |
| bilinear       | 1.42E-03 | 47.9748 | 0.9968 |  0.9992 |   |  0.0000 |   0.0000 |   0.0000 |      0.0024 |   | 0.0006 |

## Example
![JointBilateral Example](./example.png "JointBilateral Example")