texture gTexture0 < string textureState="0,Texture"; >;
float4x4 gWorldViewProjection : WORLDVIEWPROJECTION;
float visibility = 1;

sampler Sampler0 = sampler_state
{
    Texture = (gTexture0);
};

struct VSInput
{
    float3 Position : POSITION;
    float4 Diffuse  : COLOR0;
    float2 TexCoord : TEXCOORD0;
};

struct PSInput
{
    float4 Position : POSITION0;
    float4 Diffuse  : COLOR0;
    float2 TexCoord : TEXCOORD0;
    float3 InPosition : TEXCOORD1;
};

PSInput DockbarrVertexShader(VSInput VS)
{
    PSInput PS = (PSInput)0;
    PS.Position = mul(float4(VS.Position, 1), gWorldViewProjection);
    PS.Diffuse = VS.Diffuse;
    PS.TexCoord = VS.TexCoord;
    PS.InPosition = VS.Position;

    return PS;
}

float4 DockbarrPixelShader(PSInput PS) : COLOR0
{
    float4 finalColor = tex2D(Sampler0, PS.TexCoord);
    finalColor.rgb *= visibility;
    if(PS.InPosition.y < -0.1 || PS.InPosition.y > 0.1) {
        finalColor.a = 0;
    }

    return finalColor;
}

technique borsuczy_shader
{
    pass P0
    {
        VertexShader = compile vs_2_0 DockbarrVertexShader();
        PixelShader = compile ps_2_0 DockbarrPixelShader();
    }
}