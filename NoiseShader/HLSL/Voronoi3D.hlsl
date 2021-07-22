inline float3 voronoi_noise_randomVector (float3 UV, float offset){
    float3x3 m = float3x3(15.27, 47.63, 99.41, 89.98, 95.07, 38.39, 33.83, 51.06, 60.77);
    UV = frac(sin(mul(UV, m)) * 46839.32);
    return float3(sin(UV.y*+offset)*0.5+0.5, cos(UV.x*offset)*0.5+0.5, sin(UV.z*offset)*0.5+0.5);
}

void VoronoiPrecise3D_float(float3 UV, float AngleOffset, float CellDensity, out float Out, out float Cells) {
    float3 g = floor(UV * CellDensity);
    float3 f = frac(UV * CellDensity);
    float2 res = float2(8.0, 8.0);
    float3 ml = float3(0,0,0);
    float3 mv = float3(0,0,0);
 
    for(int y=-1; y<=1; y++){
        for(int x=-1; x<=1; x++){
            for(int z=-1; z<=1; z++){
                float3 lattice = float3(x, y, z);
                float3 offset = voronoi_noise_randomVector(g + lattice, AngleOffset);
                float3 v = lattice + offset - f;
                float d = dot(v, v);
    
                if(d < res.x){
                    res.x = d;
                    res.y = offset.x;
                    mv = v;
                    ml = lattice;
                }
            }
        }
    }
 
    Cells = res.y;
 
    res = float2(8.0, 8.0);
    for(int y1=-2; y1<=2; y1++){
        for(int x1=-2; x1<=2; x1++){
            for(int z1=-2; z1<=2; z1++){
                float3 lattice = ml + float3(x1, y1, z1);
                float3 offset = voronoi_noise_randomVector(g + lattice, AngleOffset);
                float3 v = lattice + offset - f;
    
                float3 cellDifference = abs(ml - lattice);
                if (cellDifference.x + cellDifference.y + cellDifference.z > 0.1){
                    float d = dot(0.5*(mv+v), normalize(v-mv));
                    res.x = min(res.x, d);
                }
            }
        }
    }
 
    Out = res.x;
}

void Voronoi3D_float(float3 UV, float AngleOffset, float CellDensity, out float Out, out float Cells) {
    float3 g = floor(UV * CellDensity);
    float3 f = frac(UV * CellDensity);
    float3 res = float3(8.0, 8.0, 8.0);
 
    for(int y=-1; y<=1; y++){
        for(int x=-1; x<=1; x++){
            for(int z=-1; z<=1; z++){
                float3 lattice = float3(x, y, z);
                float3 offset = voronoi_noise_randomVector(g + lattice, AngleOffset);
                float3 v = lattice + offset - f;
                float d = dot(v, v);
                
                if(d < res.x){
                    res.y = res.x;
                    res.x = d;
                    res.z = offset.x;
                }else if (d < res.y){
                    res.y = d;
                }
            }
        }
    }
 
    Out = res.x;
    Cells = res.z;
}