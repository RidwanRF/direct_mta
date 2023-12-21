float Brightness = 1;
float4 sLightColor = float4(1,1,1,1);
texture sTex0;
float innerSize = 1.0f;

float4x4 gWorldViewProjection : WORLDVIEWPROJECTION;

sampler Sampler0 = sampler_state
{
    Texture = (sTex0);
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
};

PSInput VertexShaderFunction(VSInput VS)
{
    PSInput PS = (PSInput)0;
    VS.Position.yz *= innerSize;

    PS.Position = mul(float4(VS.Position, 1), gWorldViewProjection);
    PS.Diffuse = VS.Diffuse;
    PS.TexCoord = VS.TexCoord;

    return PS;
}

float4 PixelShaderPS(float4 TexCoord : TEXCOORD0, float4 Position : POSITION, float4 Diffuse : COLOR0) : COLOR0
{
    float4 tex = tex2D(Sampler0, TexCoord);
    float4 output = saturate(tex * sLightColor);
    output.r *= 0.45 * Brightness;
    output.g *= 0.45 * Brightness;
    output.b *= 0.45 * Brightness;
    return output;
}

technique shader_tex_replace
{
    pass P0
    {
        VertexShader = compile vs_2_0 VertexShaderFunction();
        PixelShader = compile ps_2_0 PixelShaderPS();
        LightEnable[1] = true;
        LightEnable[2] = true;
        LightEnable[3] = true;
        LightEnable[4] = true;
    }
}

technique fallback
{
    pass P0
    {
    }
}