texture Tex0;

sampler Sampler0 = sampler_state
{
    Texture = (Tex0);
};

struct PSInput
{
    float4 Position : POSITION0;
    float4 Diffuse  : COLOR0;
    float2 TexCoord : TEXCOORD0;
};

float4 PixelShaderExample(PSInput PS) : COLOR0
{
    float4 finalColor = tex2D(Sampler0, PS.TexCoord);
    finalColor = finalColor * PS.Diffuse;
    finalColor.rgb = (finalColor.r + finalColor.g + finalColor.b)/5;
    return finalColor;
}

technique complercated
{
    pass P0
    {
        PixelShader  = compile ps_2_0 PixelShaderExample();
    }
}