//
// sm_in.fx
// version: v1.2
// author: Ren712
//

//------------------------------------------------------------------------------------------
// Variables
//------------------------------------------------------------------------------------------
float3 sCameraPosition = float3(0,0,0);
float3 sCameraForward = float3(0,0,0);
float3 sCameraUp = float3(0,0,0);
float2 sClip = float2(0.3,300);
float2 sScrRes = float2(800,600);

//------------------------------------------------------------------------------------------
// Settings
//------------------------------------------------------------------------------------------
// Secondary render target texture
texture depthRT < string renderTarget = "yes"; >;
float gAlphaRef < string renderState="ALPHAREF"; >;

//------------------------------------------------------------------------------------------
// Include some common stuff
//------------------------------------------------------------------------------------------
#include "mta-helper.fx"

//------------------------------------------------------------------------------------------
// Samplers
//------------------------------------------------------------------------------------------
sampler2D Sampler0 = sampler_state
{
    Texture = (gTexture0);
};

sampler2D SamplerDepth = sampler_state
{
    Texture = (depthRT);
    AddressU = Clamp;
    AddressV = Clamp;
    MinFilter = Point;
    MagFilter = Point;
    MipFilter = None;
    MaxMipLevel = 0;
    MipMapLodBias = 0;
};

//------------------------------------------------------------------------------------------
// Structure of data sent to the vertex shader
//------------------------------------------------------------------------------------------
struct VSInput
{
    float3 Position : POSITION0;
    float3 Normal : NORMAL0;
    float4 Diffuse : COLOR0;
    float2 TexCoord : TEXCOORD0;
};

//------------------------------------------------------------------------------------------
// Structure of data sent to the pixel shader ( from the vertex shader )
//------------------------------------------------------------------------------------------
struct PSInput
{
    float4 Position : POSITION0;
    float4 Diffuse : COLOR0;
    float2 TexCoord : TEXCOORD0;
    float3 TexProj : TEXCOORD1;
    float PlaneDist : TEXCOORD2;
    float4 Depth : TEXCOORD3;
};

//------------------------------------------------------------------------------------------
// Create view matrix 
//------------------------------------------------------------------------------------------
float4x4 createViewMatrix( float3 pos, float3 fwVec, float3 upVec )
{
    float3 zaxis = normalize( fwVec );    // The "forward" vector.
    float3 xaxis = normalize( cross( -upVec, zaxis ));// The "right" vector.
    float3 yaxis = cross( xaxis, zaxis );     // The "up" vector.

    // Create a 4x4 view matrix from the right, up, forward and eye position vectors
    float4x4 viewMatrix = {
        float4(      xaxis.x,            yaxis.x,            zaxis.x,       0 ),
        float4(      xaxis.y,            yaxis.y,            zaxis.y,       0 ),
        float4(      xaxis.z,            yaxis.z,            zaxis.z,       0 ),
        float4(-dot( xaxis, pos ), -dot( yaxis, pos ), -dot( zaxis, pos ),  1 )
    };
    return viewMatrix;
}

//--------------------------------------------------------------------------------------
// Create projection matrix 
//--------------------------------------------------------------------------------------
float4x4 createProjectionMatrix(float near_plane, float far_plane, float fov_horiz, float fov_aspect)
{
    float h, w, Q;

    w = 1/tan(fov_horiz * 0.5);
    h = w / fov_aspect;
    Q = far_plane/(far_plane - near_plane);

    float4x4 projectionMatrix = {
        float4(      w,            0,        0,             0 ),
        float4(      0,            h,        0,             0 ),
        float4(      0,            0,        Q,             1 ),
        float4(      0,            0,        -Q*near_plane, 0 )
    };    
    return projectionMatrix;
}

//------------------------------------------------------------------------------------------
// Create orthographic projection matrix 
//------------------------------------------------------------------------------------------
float4x4 createOrthographicProjectionMatrix(float near_plane, float far_plane, float viewport_sizeX, float viewport_sizeY)
{
    float sizeX = 2 / viewport_sizeX;
    float sizeY = 2 / viewport_sizeY;
	
    float4x4 projectionMatrix = {
        float4(sizeX, 0,    0,  0),
        float4(0, sizeY, 0, 0),
        float4(0, 0, 1.0 / (near_plane - far_plane), 0),
        float4(0, 0, near_plane / (near_plane - far_plane ), 1)
    };

    return projectionMatrix;
}

//------------------------------------------------------------------------------------------
// VertexShaderFunction
//------------------------------------------------------------------------------------------
PSInput VertexShaderFunction(VSInput VS )
{
    PSInput PS = (PSInput)0;

    // calculate screen pos of vertex
    float4 worldPos = mul(float4(VS.Position.xyz,1), gWorld);
	
    // normalize vectors
    float3 cameraForward = normalize(sCameraForward);
    float3 cameraUp = normalize(sCameraUp);
	
    // create ViewMatrix
    float4x4 sView = createViewMatrix(sCameraPosition, cameraForward, cameraUp);
	
    // create ProjectionMatrix
    //float4x4 sProjection = createProjectionMatrix(sClip.x, sClip.y, radians(70), 0.75);
    float4x4 sProjection = createOrthographicProjectionMatrix(-sClip.y, sClip.y, sScrRes.x, sScrRes.y);
	
    // pass vertex position to pixel shader
    float4 viewPos = mul(worldPos, sView);
    PS.Position = mul(viewPos, sProjection);
	
    // get distance form plane
    PS.PlaneDist = dot(cameraForward, worldPos.xyz - sCameraPosition);

    // pass through tex coord
    PS.TexCoord = VS.TexCoord;

    // set texCoords for projective texture
    float projectedX = (0.5 * (PS.Position.w + PS.Position.x));
    float projectedY = (0.5 * (PS.Position.w - PS.Position.y));
    PS.TexProj.xyz = float3(projectedX, projectedY, PS.Position.w);  
	
    // calculate vertex lighting
    PS.Diffuse = MTACalcGTAVehicleDiffuse(MTACalcWorldNormal( VS.Normal ), VS.Diffuse);
	
    // pass depth
    PS.Depth = float4(viewPos.z, viewPos.w, sClip[0], sClip[1]);
	
    return PS;
}

//------------------------------------------------------------------------------------------
// Pack Unit Float [0,1] into RGB24
//------------------------------------------------------------------------------------------
float3 UnitToColor24New(in float depth) 
{
    // Constants
    const float3 scale	= float3(1.0, 256.0, 65536.0);
    const float2 ogb	= float2(65536.0, 256.0) / 16777215.0;
    const float normal	= 256.0 / 255.0;
	
    // Avoid Precision Errors
    float3 unit	= (float3)depth;
    unit.gb	-= floor(unit.gb / ogb) * ogb;
	
    // Scale Up
    float3 color = unit * scale;
	
    // Use Fraction to emulate Modulo
    color = frac(color);
	
    // Normalize Range
    color *= normal;
	
    // Mask Noise
    color.rg -= color.gb / 256.0;

    return color;
}

//------------------------------------------------------------------------------------------
// Unpack RGB24 into Unit Float [0,1]
//------------------------------------------------------------------------------------------
float ColorToUnit24New(in float3 color) {
    const float3 scale = float3(65536.0, 256.0, 1.0) / 65793.0;
    return dot(color, scale);
}

//------------------------------------------------------------------------------------------
// Pack Unil float [nearClip,farClip] Unit Float [0,1]
//------------------------------------------------------------------------------------------
float DistToUnit(in float dist, in float nearClip, in float farClip) 
{
    float unit = (dist - nearClip) / (farClip - nearClip);
    return unit;
}

//------------------------------------------------------------------------------------------
// Pack Unit Float [0,1] to Unil float [nearClip,farClip]
//------------------------------------------------------------------------------------------
float UnitToDist(in float unit, in float nearClip, in float farClip) 
{
    float dist = (dist * (farClip - nearClip)) + nearClip;
    return dist;
}

//------------------------------------------------------------------------------------------
// Structure of color data sent to the renderer ( from the pixel shader  )
//------------------------------------------------------------------------------------------
struct Pixel
{
    float4 World : COLOR0;      // Render target #0
    float4 Depth : COLOR1;      // Render target #2
};

//------------------------------------------------------------------------------------------
// PixelShaderFunction
//------------------------------------------------------------------------------------------
Pixel PixelShaderFunction(PSInput PS)
{
    Pixel output;

    // get texture pixel
    float4 texel = tex2D(Sampler0, PS.TexCoord);
	
    // get projective texture coords	
    float2 TexProj = PS.TexProj.xy / PS.TexProj.z;
    TexProj += float2(0.0006, 0.0006);

    // check if pixel is drawn in front of camera plane
    if (PS.PlaneDist > 0)
    {	
        // how can eyes be real if mirrors aint real ?
        output.World = float4(0, 0, 0, 0);
    }
    else
    {
        // draw nothing
        output.World = 0;
        output.Depth = 0;  
        return output;
    }	
		
    // get current pixel depth [0 - 1]
    float depth = DistToUnit(PS.Depth.x / PS.Depth.y, sClip.x, sClip.y);

    // get packed depth texture
    float3 packedDepth = tex2D(SamplerDepth, TexProj).rgb;
	
    // unpack depth texture
    float depthVal = ColorToUnit24New(packedDepth);
	
    // compare with current pixel depth
    if ((depthVal >= depth) && (PS.PlaneDist > 0))
    {
        // depth render target
        output.Depth.rgb = UnitToColor24New(depth);
		float alphaVal = (texel.a * PS.Diffuse.a) > gAlphaRef ? 1 : 0;
        output.Depth.a = alphaVal;
    }
    else
    {
        // depth render target
        output.Depth = 0;
    }
    
    return output;
}

//------------------------------------------------------------------------------------------
// Techniques
//------------------------------------------------------------------------------------------
technique sm_in
{
    pass P0
    {
        AlphaBlendEnable = true;
        AlphaTestEnable = false;
        AlphaFunc = GreaterEqual;
        ShadeMode = Gouraud;
        ZEnable = false;
        FogEnable = false;
        SrcBlend = SrcAlpha;
        DestBlend = InvSrcAlpha;
        DitherEnable = false;
        StencilEnable = false;		
        VertexShader = compile vs_3_0 VertexShaderFunction();
        PixelShader = compile ps_3_0 PixelShaderFunction();
    }
}

// Fallback
technique fallback
{
    pass P0
    {
        // Just draw normally
    }
}
