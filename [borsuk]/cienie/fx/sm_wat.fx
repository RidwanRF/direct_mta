struct PSInput
{
    float4 Position : POSITION0;
    float4 TexCoord : TEXCOORD0;
    float4 Diffuse : COLOR0;
};

float4 PixelShaderFunction(PSInput PS) : COLOR0
{
    // how can eyes be real if mirrors aint real ?
    float alphaVal = PS.Diffuse.a > 0.05 ? 0.006105 : 0;
    return float4(0, 0, 0, alphaVal);
}

technique sm_wat_mask
{
    pass P0
    {
        AlphaBlendEnable = true;
        AlphaRef = 1;
        ZEnable = true;
        ZWriteEnable = true;
        FogEnable = false;
        PixelShader = compile ps_2_0 PixelShaderFunction();
    }
}