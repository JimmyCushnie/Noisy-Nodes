inline float4 voronoi_noise_randomVector (float4 UV, float offset){
    float4x4 m = float4x4(15.27, 47.63, 99.41, 89.98, 95.07, 38.39, 33.83, 51.06, 60.77, 51.15, 92.33, 97.74, 59.93, 42.33, 60.13, 35.72);
    UV = frac(sin(mul(UV, m)) * 46839.32);
    return float4(sin(UV.y*+offset)*0.5+0.5, cos(UV.x*offset)*0.5+0.5, sin(UV.z*offset)*0.5+0.5, cos(UV.w*offset)*0.5+0.5);
}

void VoronoiPrecise4D_float(float4 UV, float AngleOffset, float CellDensity, out float Out, out float Cells) {
    float4 g = floor(UV * CellDensity);
    float4 f = frac(UV * CellDensity);
    float2 res = float2(8.0, 8.0);
    float4 ml = float4(0,0,0,0);
    float4 mv = float4(0,0,0,0);
 
    for(int y=-1; y<=1; y++){
        for(int x=-1; x<=1; x++){
            for(int z=-1; z<=1; z++){
                for (int w = -1; w <= 1; w++) {
                    float4 lattice = float4(x, y, z, w);
                    float4 offset = voronoi_noise_randomVector(g + lattice, AngleOffset);
                    float4 v = lattice + offset - f;
                    float d = dot(v, v);

                    if (d < res.x) {
                        res.x = d;
                        res.y = offset.x;
                        mv = v;
                        ml = lattice;
                    }
                }
            }
        }
    }
 
    Cells = res.y;
 
    res = float2(8.0, 8.0);
    for(int y1=-2; y1<=2; y1++){
        for(int x1=-2; x1<=2; x1++){
            for(int z1=-2; z1<=2; z1++){
                for (int w1 = -2; w1 <= 2; w1++) {
                    float4 lattice = ml + float4(x1, y1, z1, w1);
                    float4 offset = voronoi_noise_randomVector(g + lattice, AngleOffset);
                    float4 v = lattice + offset - f;

                    float4 cellDifference = abs(ml - lattice);
                    if (cellDifference.x + cellDifference.y + cellDifference.z + cellDifference.w > 0.1) {
                        float d = dot(0.5 * (mv + v), normalize(v - mv));
                        res.x = min(res.x, d);
                    }
                }
            }
        }
    }
 
    Out = res.x;
}

void Voronoi4D_float(float4 UV, float AngleOffset, float CellDensity, out float Out, out float Cells) {
    float4 g = floor(UV * CellDensity);
    float4 f = frac(UV * CellDensity);
    float3 res = float3(8.0, 8.0, 8.0);
 
    for(int y=-1; y<=1; y++){
        for(int x=-1; x<=1; x++){
            for(int z=-1; z<=1; z++){
                for (int w = -1; w <= 1; w++) {
                    float4 lattice = float4(x, y, z, w);
                    float4 offset = voronoi_noise_randomVector(g + lattice, AngleOffset);
                    float4 v = lattice + offset - f;
                    float d = dot(v, v);

                    if (d < res.x) {
                        res.y = res.x;
                        res.x = d;
                        res.z = offset.x;
                    }
                    else if (d < res.y) {
                        res.y = d;
                    }
                }
            }
        }
    }
 
    Out = res.x;
    Cells = res.z;
}