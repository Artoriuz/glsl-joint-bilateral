// MIT License

// Copyright (c) 2023 João Chrisóstomo

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

//!PARAM length
//!TYPE int
//!MINIMUM 1
4

//!PARAM distance_coeff
//!TYPE float
//!MINIMUM 0.0
1

//!PARAM intensity_coeff
//!TYPE float
//!MINIMUM 0.0
64.0

//!HOOK CHROMA
//!BIND CHROMA
//!BIND LUMA
//!WIDTH LUMA.w
//!HEIGHT LUMA.h
//!WHEN CHROMA.w LUMA.w <
//!OFFSET ALIGN
//!DESC JointBilateral

float comp_wd(vec2 distance) {
    float d2 = distance.x*distance.x + distance.y*distance.y;
    return exp(distance_coeff * d2);
}

float comp_wi(float distance) {
    if (distance < 0.1) {
        return 1.0;
    } else {
        distance -= 0.1;
        return exp(-intensity_coeff * distance);
    }
}

vec4 hook() {
    vec2 pp = CHROMA_pos * CHROMA_size - vec2(0.5);
    vec2 fp = floor(pp);
    pp -= fp;

    float luma_centre = LUMA_texOff(0).x;
    float accumulated_weight = 0.0;
    vec2 accumulated_colour = vec2(0.0);
    int radius = length / 2;
    for (int y = -radius + 1; y <= radius; y++) {
        for (int x = -radius + 1; x <= radius; x++) {
            vec2 cur_pos = (fp + vec2(0.5) + vec2(y, x)) * CHROMA_pt;
            vec2 chroma_pix = CHROMA_tex(cur_pos).xy;
            float luma_pix = LUMA_tex(cur_pos).x;

            vec2 pix_distance = vec2(distance(CHROMA_pos, (fp + vec2(y + 0.5, x + 0.5)) * CHROMA_pt));
            float distance_weight = comp_wd(pix_distance);
            
            float intensity_diff = abs(luma_pix - luma_centre);
            float intensity_weight = comp_wi(intensity_diff);
            
            float final_weight = distance_weight * intensity_weight;
            accumulated_weight += final_weight;
            accumulated_colour += final_weight * chroma_pix;
        }
    }

    vec4 output_pix = vec4(0.0, 0.0, 0.0, 1.0);
    output_pix.xy = accumulated_colour / accumulated_weight;
    return  output_pix;
}