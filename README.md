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
| cflmix         | 2.80E-03 | 44.1411 | 0.9939 |  0.9987 |   |  0.9526 |   0.9920 |   1.0000 |      0.9634 |   | 0.9770 |
| krigbilateral  | 2.84E-03 | 44.1645 | 0.9936 |  0.9988 |   |  0.9147 |   1.0000 |   0.9004 |      1.0000 |   | 0.9538 |
| cfl4           | 2.76E-03 | 43.5243 | 0.9934 |  0.9987 |   |  1.0000 |   0.7806 |   0.8529 |      0.9041 |   | 0.8844 |
| cfl12          | 2.96E-03 | 43.7869 | 0.9935 |  0.9986 |   |  0.7750 |   0.8706 |   0.8573 |      0.8368 |   | 0.8349 |
| cfl16          | 3.18E-03 | 43.2266 | 0.9927 |  0.9983 |   |  0.5281 |   0.6786 |   0.6234 |      0.6358 |   | 0.6165 |
| jointbilateral | 3.23E-03 | 42.6935 | 0.9918 |  0.9985 |   |  0.4768 |   0.4960 |   0.3555 |      0.7873 |   | 0.5289 |
| fastbilateral  | 3.22E-03 | 42.5671 | 0.9918 |  0.9985 |   |  0.4906 |   0.4527 |   0.3546 |      0.7554 |   | 0.5133 |
| lanczos        | 3.41E-03 | 42.0579 | 0.9918 |  0.9975 |   |  0.2756 |   0.2782 |   0.3664 |      0.0549 |   | 0.2438 |
| polar_lanczos  | 3.43E-03 | 42.0058 | 0.9917 |  0.9975 |   |  0.2525 |   0.2603 |   0.3455 |      0.0384 |   | 0.2242 |
| bilinear       | 3.65E-03 | 41.2460 | 0.9906 |  0.9975 |   |  0.0000 |   0.0000 |   0.0000 |      0.0000 |   | 0.0000 |

As you can see in the table above, the newest test-image doesn't pain these shaders as amazing anymore, and I've learnt that the results highly depend on content. For highly detailed content, where you have a lot of high-frequency information (sharp transitions with grandient reversals), these shaders will help a lot with tightening chroma to luma, and the scores will generally be much higher. With normal anime-like video content however, it doesn't look like 
they help that much, and the fact that the spatial filters employed here are soft by nature means the shader can only produce good results when there are good luma transitions to guide it.

TLDL: These shaders are hit or miss, sometimes they're very good and sometimes they're just OK. Use [CfL](https://github.com/Artoriuz/glsl-chroma-from-luma-prediction) if you need something that's more consistent.

## Example
![JointBilateral Example](./example.png "JointBilateral Example")