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
| Shader/Filter  | MAE    | PSNR    | SSIM   | MS-SSIM |   | MAE (N) | PSNR (N) | SSIM (N) | MS-SSIM (N) |   | Mean   |
|----------------|--------|---------|--------|---------|---|---------|----------|----------|-------------|---|--------|
| cfl_4tap       | 0.0015 | 48.5037 | 0.9968 |  0.9996 |   |  1.0000 |   1.0000 |   1.0000 |      1.0000 |   | 1.0000 |
| cfl_mix        | 0.0017 | 48.1647 | 0.9966 |  0.9995 |   |  0.7061 |   0.8500 |   0.8112 |      0.7823 |   | 0.7874 |
| krigbilateral  | 0.0016 | 48.0584 | 0.9965 |  0.9996 |   |  0.7693 |   0.8030 |   0.6716 |      0.8727 |   | 0.7792 |
| cfl_12tap      | 0.0018 | 47.4755 | 0.9963 |  0.9995 |   |  0.4527 |   0.5452 |   0.4381 |      0.5351 |   | 0.4928 |
| lanczos        | 0.0018 | 47.1755 | 0.9965 |  0.9994 |   |  0.3855 |   0.4125 |   0.6601 |      0.2760 |   | 0.4335 |
| polar_lanczos  | 0.0018 | 47.0847 | 0.9964 |  0.9994 |   |  0.3304 |   0.3724 |   0.6088 |      0.2114 |   | 0.3808 |
| fastbilateral  | 0.0018 | 46.7015 | 0.9960 |  0.9994 |   |  0.2582 |   0.2029 |   0.2112 |      0.4364 |   | 0.2772 |
| cfl_16tap      | 0.0019 | 46.9027 | 0.9959 |  0.9994 |   |  0.1161 |   0.2919 |   0.0829 |      0.2254 |   | 0.1791 |
| jointbilateral | 0.0019 | 46.5899 | 0.9958 |  0.9994 |   |  0.1089 |   0.1535 |   0.0000 |      0.3971 |   | 0.1649 |
| bilinear       | 0.0020 | 46.2429 | 0.9958 |  0.9993 |   |  0.0000 |   0.0000 |   0.0083 |      0.0000 |   | 0.0021 |

As you can see in the table above, the newest test-image doesn't pain these shaders as amazing anymore, and I've learnt that the results highly depend on content. For highly detailed content, where you have a lot of high-frequency information (sharp transitions with grandient reversals), these shaders will help a lot with tightening chroma to luma, and the scores will generally be much higher. With normal anime-like video content however, it doesn't look like 
they help that much, and the fact that the spatial filters employed here are soft by nature means the shader can only produce good results when there are good luma transitions to guide it.

TLDL: These shaders are hit or miss, sometimes they're very good and sometimes they're just OK. Use [CfL](https://github.com/Artoriuz/glsl-chroma-from-luma-prediction) if you need something that's more consistent.

## Example
![JointBilateral Example](./example.png "JointBilateral Example")