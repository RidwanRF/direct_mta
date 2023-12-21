float sCircleHeightInPixel = 100;
float sCircleWidthInPixel = 100;
float sBorderWidthInPixel = 10;
float sAngleStart = -3.14;
float sAngleEnd = 3.14;
float aaSize = 5;

float4 PixelShaderFunction(float4 Diffuse : COLOR0, float2 TexCoord : TEXCOORD0) : COLOR0
{
    float2 uv = float2( TexCoord.x, TexCoord.y ) - float2( 0.5, 0.5 );

    float angle = atan2( -uv.x, uv.y );  // -PI to +PI
    if(angle > sAngleStart && angle < sAngleEnd) {
        // Calc border width to use
        float2 vec = normalize( uv );
        float CircleRadiusInPixel = lerp( sCircleWidthInPixel, sCircleHeightInPixel, vec.y * vec.y );
        float borderWidth = sBorderWidthInPixel / CircleRadiusInPixel;

        // Check if pixel is inside circle
        float dist =  sqrt( dot( uv, uv ) );
        float aa = aaSize/CircleRadiusInPixel;
        float t = (
            (dist < 0.5 && dist > 0.5 - borderWidth) ? (
            (dist > 0.5 - aa) ? (
                1-(dist - (0.5 - aa))/aa
            ) : (
                (dist < 0.5 - borderWidth + aa) ? (
                    (dist - (0.5 - borderWidth))/aa
                ) : 1
            )
        ) : 0);
        return lerp(float4(Diffuse.rgb, 0), Diffuse, t);
    }

    return 0;
}

technique tec0
{
    pass P0
    {
        PixelShader = compile ps_2_0 PixelShaderFunction();
    }
}