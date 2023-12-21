texture Tex0;
texture Tex1;
float interpolation;

sampler Sampler0 = sampler_state
{
    Texture = (Tex0);
};

sampler Sampler1 = sampler_state
{
    Texture = (Tex1);
};

struct PSInput
{
    float4 Position : POSITION0;
    float4 Diffuse  : COLOR0;
    float2 TexCoord : TEXCOORD0;
};

float4 PixelShaderExample(PSInput PS) : COLOR0
{
    float4 color0 = tex2D(Sampler0, PS.TexCoord) * PS.Diffuse;
    float4 color1 = tex2D(Sampler1, PS.TexCoord) * PS.Diffuse;

    return lerp(color0, color1, interpolation);
}

technique replace
{
    pass P0
    {
        PixelShader  = compile ps_2_0 PixelShaderExample();
    }
}