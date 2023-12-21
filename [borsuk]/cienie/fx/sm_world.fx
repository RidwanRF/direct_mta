//
// Example shader - roadshine.fx
//


//---------------------------------------------------------------------
// Road shine settings
//---------------------------------------------------------------------
texture sRTNormal < string renderTarget = "yes"; >;

//---------------------------------------------------------------------
// Include some common stuff
//---------------------------------------------------------------------
#define GENERATE_NORMALS      // Uncomment for normals to be generated
#include "mta-helper.fx"


//---------------------------------------------------------------------
// Sampler for the main texture
//---------------------------------------------------------------------
sampler Sampler0 = sampler_state
{
    Texture = (gTexture0);
};

sampler2D SamplerNormal = sampler_state
{
    Texture = (sRTNormal);
    AddressU = Clamp;
    AddressV = Clamp;
    MinFilter = Point;
    MagFilter = Point;
    MipFilter = None;
    MaxMipLevel = 0;
    MipMapLodBias = 0;
};

//---------------------------------------------------------------------
// Structure of data sent to the vertex shader
//---------------------------------------------------------------------
struct VSInput
{
  float3 Position : POSITION0;
  float3 Normal : NORMAL0;
  float4 Diffuse : COLOR0;
  float2 TexCoord : TEXCOORD0;
};

//---------------------------------------------------------------------
// Structure of data sent to the pixel shader ( from the vertex shader )
//---------------------------------------------------------------------
struct PSInput
{
  float4 Position : POSITION0;
  float4 Diffuse : COLOR0;
  float2 TexCoord : TEXCOORD0;
  float3 WorldNormal : TEXCOORD1;
  float3 WorldPos : TEXCOORD2;
};


//------------------------------------------------------------------------------------------
// VertexShaderFunction
//  1. Read from VS structure
//  2. Process
//  3. Write to PS structure
//------------------------------------------------------------------------------------------
PSInput VertexShaderFunction(VSInput VS)
{
    PSInput PS = (PSInput)0;

    // Make sure normal is valid
    MTAFixUpNormal( VS.Normal );

    // Calculate screen pos of vertex
    PS.Position = MTACalcScreenPosition ( VS.Position );

    // Pass through tex coord
    PS.TexCoord = VS.TexCoord;

    // Calculate GTA lighting for buildings
    PS.Diffuse = MTACalcGTAVehicleDiffuse( MTACalcWorldNormal( VS.Normal ), VS.Diffuse );

    // Set information to do specular calculation in pixel shader
    PS.WorldNormal = MTACalcWorldNormal( VS.Normal );
    PS.WorldPos = MTACalcWorldPosition( VS.Position );

    return PS;
}

//------------------------------------------------------------------------------------------
// Structure of color data sent to the renderer ( from the pixel shader  )
//------------------------------------------------------------------------------------------
struct PixelType1
{
    float4 World : COLOR0;      // Render target #0
    float4 Normal : COLOR1;      // Render target #1
};

//------------------------------------------------------------------------------------------
// PixelShaderFunction
//  1. Read from PS structure
//  2. Process
//  3. Return pixel color
//------------------------------------------------------------------------------------------
PixelType1 PixelShaderFunction(PSInput PS)
{
    PixelType1 Output;
    // Get texture pixel
    float4 texel = tex2D(Sampler0, PS.TexCoord);

    // Apply diffuse lighting
    float4 finalColor = texel * PS.Diffuse;
	
    Output.World = finalColor;
    if (finalColor.a > 0.20) Output.Normal = float4(float3((PS.WorldNormal * 0.5) + 0.5), 1);
        else Output.Normal = 0;
	
    return Output;
}


//------------------------------------------------------------------------------------------
// Techniques
//------------------------------------------------------------------------------------------
technique getStuff
{
    pass P0
    {
        VertexShader = compile vs_2_0 VertexShaderFunction();
        PixelShader = compile ps_2_0 PixelShaderFunction();
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
