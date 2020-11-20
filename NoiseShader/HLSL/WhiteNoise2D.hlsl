#include "NoiseUtils.hlsl"

void WhiteNoise2D_float(float2 input, out float Out)
{
    Out = rand2dTo1d(input);
}