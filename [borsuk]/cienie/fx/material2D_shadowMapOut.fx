//
// file: material2D_shadowMapOut.fx
// version: v1.5
// author: Ren712
//

//--------------------------------------------------------------------------------------
// Settings
//--------------------------------------------------------------------------------------

float3 sElementPosition = float3(0, 0, 0);
float2 fViewportSize = float2(800, 600);
float2 fViewportScale = float2(1, 1);
float2 fViewportPos = float2(0, 0);

float sZRotation = 0;
float2 sZRotationCenterOffset = float2(0, 0);

float2 sPixelSize = float2(0.00125, 0.00166);
float2 sTexSize = float2(800, 600);
float sAspectRatio = 800 / 600;

float3 sCameraPosition = float3(0,0,0);
float3 sCameraForward = float3(0,0,0);
float3 sCameraUp = float3(0,0,0);
float2 sClip = float2(0.3,300);
float2 sScrRes = float2(800,600);
float2 sScrRes_det = float2(800,600);

uniform float fMXAOAmbientOcclusionAmount = 2; // 2 Ambient Occlusion Amount (0 - 3)
uniform float fMXAOFadeoutStart = 0.8; // Fadeout start (0 -1)
uniform float fMXAOFadeoutEnd = 0.9; // Fadeout end (0 - 1)

#define AO_BLUR_GAMMA   2
#define fMXAOBlurSteps  4  // Blur Steps. Offset count for AO bilateral blur filter. Higher means smoother but also blurrier AO. (int 2 - 5)
#define fMXAOBlurSharpness 5.00 // 2 Blur Sharpness. AO sharpness, higher means sharper geometry edges but noisier AO, less means smoother AO but blurry in the distance. (0 - 5)

#define iMXAOBayerDitherLevel  5 // Dither Size (int 2 - 8)
uniform float fMXAOSampleRadius = 1.7; // 1.50 Sample radius of GI, higher means more large-scale occlusion with less fine-scale details.  (1 - 8)
#define iMXAOSampleCount 24 // Amount of MXAO samples. Higher means more accurate and less noisy AO at the cost of fps (int 8 - 255)
//#define AO_BLUR_GAMMA 2
uniform float fMXAONormalBias = 0.2; // 0.2 Normal bias. Normals bias to reduce self-occlusion of surfaces that have a low angle to each other. (0 - 0.8)

//#define fMXAOBlurSteps  3  // Blur Steps. Offset count for AO bilateral blur filter. Higher means smoother but also blurrier AO. (int 2 - 5)
//#define fMXAOBlurSharpness 3.00 // 2 Blur Sharpness. AO sharpness, higher means sharper geometry edges but noisier AO, less means smoother AO but blurry in the distance. (0 - 5)

//uniform float fMXAOAmbientOcclusionAmount = 1.2; // 2 Ambient Occlusion Amount (0 - 3)
//uniform float fMXAOFadeoutStart = 0.8; // Fadeout start (0 -1)
//uniform float fMXAOFadeoutEnd = 0.9; // Fadeout end (0 - 1)

//--------------------------------------------------------------------------------------
// Textures
//--------------------------------------------------------------------------------------
// Secondary render target textures
texture sRTColor < string renderTarget = "yes"; >;
texture sRTNormal < string renderTarget = "yes"; >;
texture sRTDepth;
texture sRTDepthDet;

//--------------------------------------------------------------------------------------
// Variables set by MTA
//--------------------------------------------------------------------------------------
texture gDepthBuffer : DEPTHBUFFER;
float4x4 gProjection : PROJECTION;
float4x4 gView : VIEW;
float4x4 gViewInverse : VIEWINVERSE;
float3 gCameraPosition : CAMERAPOSITION;
int gFogEnable < string renderState="FOGENABLE"; >;
float4 gFogColor < string renderState="FOGCOLOR"; >;
float gFogStart < string renderState="FOGSTART"; >;
float gFogEnd < string renderState="FOGEND"; >;
int gCapsMaxAnisotropy < string deviceCaps="MaxAnisotropy"; >;
int CUSTOMFLAGS < string skipUnusedParameters = "yes"; >;

//--------------------------------------------------------------------------------------
// Sampler 
//--------------------------------------------------------------------------------------
sampler2D SamplerColor = sampler_state
{
    Texture = (sRTColor);
    AddressU = Clamp;
    AddressV = Clamp;
    MinFilter = Point;
    MagFilter = Point;
    MipFilter = None;
    MaxMipLevel = 0;
    MipMapLodBias = 0;
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

sampler SamplerDepth = sampler_state
{
    Texture = (gDepthBuffer);
    AddressU = Clamp;
    AddressV = Clamp;
    MinFilter = Point;
    MagFilter = Point;
    MipFilter = None;
};

sampler SamplerCompare = sampler_state 
{
    Texture = (sRTDepth);
    AddressU = Clamp;
    AddressV = Clamp;
    MinFilter = Point;
    MagFilter = Point;
    MipFilter = None;
    MaxMipLevel = 0;
    MipMapLodBias = 0;
};

sampler SamplerCompare_det = sampler_state 
{
    Texture = (sRTDepthDet);
    AddressU = Clamp;
    AddressV = Clamp;
    MinFilter = Point;
    MagFilter = Point;
    MipFilter = None;
    MaxMipLevel = 0;
    MipMapLodBias = 0;
};

//--------------------------------------------------------------------------------------
// Structures
//--------------------------------------------------------------------------------------
struct VSInput
{
    float3 Position : POSITION0;
    float2 TexCoord : TEXCOORD0;
    float4 Diffuse : COLOR0;
};

struct PSInput
{
    float4 Position : POSITION0;
    float2 TexCoord : TEXCOORD0;
    float2 PixPos : TEXCOORD1;
    float4 Diffuse : COLOR0;
};

//--------------------------------------------------------------------------------------
// Inverse matrix
//--------------------------------------------------------------------------------------
float4x4 inverseMatrix(float4x4 input)
{
     #define minor(a,b,c) determinant(float3x3(input.a, input.b, input.c))
     
     float4x4 cofactors = float4x4(
          minor(_22_23_24, _32_33_34, _42_43_44), 
         -minor(_21_23_24, _31_33_34, _41_43_44),
          minor(_21_22_24, _31_32_34, _41_42_44),
         -minor(_21_22_23, _31_32_33, _41_42_43),
         
         -minor(_12_13_14, _32_33_34, _42_43_44),
          minor(_11_13_14, _31_33_34, _41_43_44),
         -minor(_11_12_14, _31_32_34, _41_42_44),
          minor(_11_12_13, _31_32_33, _41_42_43),
         
          minor(_12_13_14, _22_23_24, _42_43_44),
         -minor(_11_13_14, _21_23_24, _41_43_44),
          minor(_11_12_14, _21_22_24, _41_42_44),
         -minor(_11_12_13, _21_22_23, _41_42_43),
         
         -minor(_12_13_14, _22_23_24, _32_33_34),
          minor(_11_13_14, _21_23_24, _31_33_34),
         -minor(_11_12_14, _21_22_24, _31_32_34),
          minor(_11_12_13, _21_22_23, _31_32_33)
     );
     #undef minor
     return transpose(cofactors) / determinant(input);
}

//--------------------------------------------------------------------------------------
// Returns a rotation matrix (rotate by Z)
//--------------------------------------------------------------------------------------
float4x4 makeZRotation( float angleInRadians) 
{
    float c = cos(angleInRadians);
    float s = sin(angleInRadians);
  
    return float4x4(
     c, s, 0, 0,
    -s, c, 0, 0,
     0, 0, 1, 0,
     0, 0, 0, 1
  );
}

//--------------------------------------------------------------------------------------
// Returns a translation matrix
//--------------------------------------------------------------------------------------
float4x4 makeTranslation( float3 trans) 
{
    return float4x4(
     1,  0,  0,  0,
     0,  1,  0,  0,
     0,  0,  1,  0,
     trans.x, trans.y, trans.z, 1
    );
}

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

//--------------------------------------------------------------------------------------
// Creates projection matrix of a shadered dxDrawImage
//--------------------------------------------------------------------------------------
float4x4 createImageProjectionMatrix(float2 viewportPos, float2 viewportSize, float2 viewportScale, float adjustZFactor, float nearPlane, float farPlane)
{
    float Q = farPlane / ( farPlane - nearPlane );
    float rcpSizeX = 2.0f / viewportSize.x;
    float rcpSizeY = -2.0f / viewportSize.y;
    rcpSizeX *= adjustZFactor;
    rcpSizeY *= adjustZFactor;
    float viewportPosX = 2 * viewportPos.x;
    float viewportPosY = 2 * viewportPos.y;
	
    float4x4 sProjection = {
        float4(rcpSizeX * viewportScale.x, 0, 0,  0), float4(0, rcpSizeY * viewportScale.y, 0, 0), float4(viewportPosX, -viewportPosY, Q, 1),
        float4(( -viewportSize.x / 2.0f - 0.5f ) * rcpSizeX,( -viewportSize.y / 2.0f - 0.5f ) * rcpSizeY, -Q * nearPlane , 0)
    };

    return sProjection;
}

//--------------------------------------------------------------------------------------
// Vertex Shader 
//--------------------------------------------------------------------------------------
PSInput VertexShaderFunction(VSInput VS)
{
    PSInput PS = (PSInput)0;

    // set proper position of the quad
    VS.Position.xyz -= sElementPosition;
	
    // rotate
    VS.Position.xy -= 0.5 + sZRotationCenterOffset;
    VS.Position.xyz = mul(float4(VS.Position.xyz, 1), makeZRotation(sZRotation)).xyz;	
    VS.Position.xy += 0.5 + sZRotationCenterOffset;	
	
    // resize
    VS.Position.xy *= fViewportSize;

    // create projection matrix (as done for shadered dxDrawImage)
    float4x4 sProjection = createImageProjectionMatrix(fViewportPos, fViewportSize, fViewportScale, 1000, 100, 10000);
	
    // calculate screen position of the vertex
    float4 viewPos = mul(float4(VS.Position.xyz, 1), makeTranslation(float3(0,0, 1000)));
    PS.Position = mul(viewPos, sProjection);

    // pass texCoords
    PS.TexCoord = float2(1 - VS.TexCoord.x, VS.TexCoord.y);
	
    // pass screen position to be used in PS
    PS.PixPos = VS.Position.xy;
	
    // pass vertex color to PS
    PS.Diffuse = VS.Diffuse;
	
    return PS;
}

//-----------------------------------------------------------------------------
//-- Get value from the depth buffer
//-- Uses define set at compile time to handle RAWZ special case (which will use up a few more slots)
//-----------------------------------------------------------------------------
float FetchDepthBufferValue( float2 uv )
{
    float4 texel = tex2D(SamplerDepth, uv);
#if IS_DEPTHBUFFER_RAWZ
    float3 rawval = floor(255.0 * texel.arg + 0.5);
    float3 valueScaler = float3(0.996093809371817670572857294849, 0.0038909914428586627756752238080039, 1.5199185323666651467481343000015e-5);
    return dot(rawval, valueScaler / 255.0);
#else
    return texel.r;
#endif
}

//--------------------------------------------------------------------------------------
//-- Use the last scene projecion matrix to linearize the depth value a bit more
//--------------------------------------------------------------------------------------
float Linearize(float posZ)
{
    return gProjection[3][2] / (posZ - gProjection[2][2]);
}

//-----------------------------------------------------------------------------
// Fetches position relative to camera. This is somewhat inaccurate
// as it assumes FoV == 90 degrees but yields good enough results.
//-----------------------------------------------------------------------------
float3 GetPosition(float2 coords)
{
    return float3(coords.xy * 2 - 1,1.0) * Linearize(FetchDepthBufferValue(coords.xy));
}

//--------------------------------------------------------------------------------------
//-- Function for converting depth to view-space position
//-- in deferred pixel shader pass.  vTexCoord is a texture
//-- coordinate for a full-screen quad, such that x=0 is the
//-- left of the screen, and y=0 is the top of the screen.
//--------------------------------------------------------------------------------------
float3 VSPositionFromDepth(float2 vTexCoord, float4x4 g_matInvProjection)
{
    // Get the depth value for this pixel
    float z = FetchDepthBufferValue(vTexCoord); 
    // Get x/w and y/w from the viewport position
    float x = vTexCoord.x * 2 - 1;
    float y = (1 - vTexCoord.y) * 2 - 1;
    float4 vProjectedPos = float4(x, y, z, 1.0f);
    // Transform by the inverse projection matrix
    float4 vPositionVS = mul(vProjectedPos, g_matInvProjection);  
    // Divide by w to get the view-space position
    return vPositionVS.xyz / vPositionVS.w;  
}

//-----------------------------------------------------------------------------
//  Calculates normals based on partial depth buffer derivatives.
//  Does a similar job to ddx/ddy but this is higher quality and
//  it also takes care for object borders where usual ddx/ddy produce
//  inaccurate normals.
//-----------------------------------------------------------------------------
float3 GetNormalFromDepth(float2 coords)
{
    float3 offs = float3(sPixelSize.xy, 0);

    float3 f = GetPosition(coords.xy);
    float3 d_dx1 = - f + GetPosition(coords.xy + offs.xz);
    float3 d_dx2 =   f - GetPosition(coords.xy - offs.xz);
    float3 d_dy1 = - f + GetPosition(coords.xy + offs.zy);
    float3 d_dy2 =   f - GetPosition(coords.xy - offs.zy);

    d_dx1 = lerp(d_dx1, d_dx2, abs(d_dx1.z) > abs(d_dx2.z));
    d_dy1 = lerp(d_dy1, d_dy2, abs(d_dy1.z) > abs(d_dy2.z));

    float3 ddxDdy = normalize(cross(d_dy1, d_dx1));
    return  float3(ddxDdy.x, -ddxDdy.y, ddxDdy.z);
}

//--------------------------------------------------------------------------------------
// More accurate than GetNormalFromDepth, calculates normals based on
// view position, unlike GetPosition, takes current field of view into account
//--------------------------------------------------------------------------------------
float3 GetNormalFromDepthProjection(float2 coords, float4x4 g_matInvProjection)
{
    float3 offs = float3(sPixelSize.xy, 0);

    float3 f = VSPositionFromDepth(coords.xy, g_matInvProjection);
    float3 d_dx1 = - f + VSPositionFromDepth(coords.xy + offs.xz, g_matInvProjection);
    float3 d_dx2 =   f - VSPositionFromDepth(coords.xy - offs.xz, g_matInvProjection);
    float3 d_dy1 = - f + VSPositionFromDepth(coords.xy + offs.zy, g_matInvProjection);
    float3 d_dy2 =   f - VSPositionFromDepth(coords.xy - offs.zy, g_matInvProjection);

    d_dx1 = lerp(d_dx1, d_dx2, abs(d_dx1.z) > abs(d_dx2.z));
    d_dy1 = lerp(d_dy1, d_dy2, abs(d_dy1.z) > abs(d_dy2.z));

    return (- normalize(cross(d_dy1, d_dx1)));
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
    float dist = (unit * (farClip - nearClip)) + nearClip;
    return dist;
}

//------------------------------------------------------------------------------------------
// Structure of color data sent to the renderer ( from the pixel shader  )
//------------------------------------------------------------------------------------------
struct PixelType2
{
    float4 World : COLOR0;      // Render target #0
    float4 Color : COLOR1;      // Render target #1
    float4 Normal : COLOR2;      // Render target #2
};

struct PixelType1
{
    float4 World : COLOR0;      // Render target #0
    float4 Color : COLOR1;      // Render target #1
};

//-----------------------------------------------------------------------------
//-- Pixel Shader
//-----------------------------------------------------------------------------
PixelType2 PixelShaderFunctionShadow(PSInput PS)
{
    PixelType2 Output;
    // get depthBuffer and limit the effect
    float BufferValue = FetchDepthBufferValue(PS.TexCoord.xy);
    if (BufferValue > 0.9999)
    {
        Output.Color = 0;
        Output.World = 0;
        Output.Normal = 0;
        return Output;		
    }	

    // shit to stuff pixel shader with
    float4x4 sProjectionInverse = inverseMatrix(gProjection);
    float4x4 sViewProjectionInverse = mul(gViewInverse, sProjectionInverse);
	
    // recreate world position from pixel depth
    float3 viewPos = VSPositionFromDepth(PS.TexCoord, sProjectionInverse);
    float3 worldPos = mul(float4(viewPos, 1), gViewInverse).xyz;
    float camDist = distance( gCameraPosition, worldPos.xyz ) / Linearize(1);
	
    // recreate world normal from pixel depth
    float3 viewNormal = GetNormalFromDepthProjection(PS.TexCoord.xy, sProjectionInverse);
    float3 worldNormal = mul(viewNormal, (float3x3)gViewInverse).xyz;
	
    // getWorldNormal from texture
    float3 normalTex = tex2D(SamplerNormal, PS.TexCoord.xy).xyz;
    if (length(normalTex) < 0.5) Output.Normal = float4((worldNormal * 0.5) + 0.5, 1);
        else {Output.Normal = 0; worldNormal = (normalTex - 0.5) * 2;}
    // normalize vectors
    float3 cameraForward = normalize(sCameraForward);
    float3 cameraUp = normalize(sCameraUp);
	
    // calc directional light
    float3 LDotN =  -dot(cameraForward, worldNormal) < 0.15 ? 0 : 1;

    // create ViewMatrix
    float4x4 sViewProj = createViewMatrix(sCameraPosition, cameraForward, cameraUp);
	
    // create ProjectionMatrix
    float4x4 sProjectionProj = createOrthographicProjectionMatrix(-sClip.y, sClip.y, sScrRes.x, sScrRes.y);
	
    // create Projected texture coordinates
    float4 viewPosProj = mul(float4(worldPos, 1), sViewProj);
    float4 projPosProj = mul(viewPosProj, sProjectionProj);
    float projX = (0.5 * (projPosProj.w + projPosProj.x));
    float projY = (0.5 * (projPosProj.w - projPosProj.y));
    float2 projCoord = float2(projX, projY) / projPosProj.w;
	
    // create ProjectionMatrix (detail)
    float4x4 sProjectionProjDet = createOrthographicProjectionMatrix(-sClip.y, sClip.y, sScrRes_det.x, sScrRes_det.y);
	
    // create Projected texture coordinates (detail)
    float4 projPosProjD = mul(viewPosProj, sProjectionProjDet);
    float projXD = (0.5 * (projPosProjD.w + projPosProjD.x));
    float projYD = (0.5 * (projPosProjD.w - projPosProjD.y));
    float2 projCoordD = float2(projXD, projYD) / projPosProjD.w;

    // compare between scene depth from 2 pointes in 3D space
    float4 color = 0;	
    if ((projCoord.x >= 0) && (projCoord.x <= 1) && (projCoord.y >= 0) && (projCoord.y <= 1))
    {
        float pixDist = viewPosProj.z / viewPosProj.w;
        float linDepth = 0;

        if ((projCoordD.x >= 0) && (projCoordD.x <= 1) && (projCoordD.y >= 0) && (projCoordD.y <= 1))
        {		
            // get packed depth texture
            float3 packedDepth = tex2D(SamplerCompare_det, projCoordD.xy).rgb;
            float unpackedDepth = ColorToUnit24New(packedDepth.rgb);
            linDepth = UnitToDist(unpackedDepth, sClip.x, sClip.y);
        }
        else
        {
            // get packed depth texture
            float3 packedDepth = tex2D(SamplerCompare, projCoord.xy).rgb;
            float unpackedDepth = ColorToUnit24New(packedDepth.rgb);
            linDepth = UnitToDist(unpackedDepth, sClip.x, sClip.y);
        }
		
        // make shadow
		float3 depthDif = (linDepth - pixDist) > -0.03 ? 1 : 0;
        depthDif = min(LDotN, depthDif);

        Output.World = 0;
		Output.Color = float4(depthDif.x, camDist, 0, 1);
    }
    else
    {
        Output.World = 0;
		Output.Color = float4(1, camDist, 0, 1);
    }
    return Output;
}

//------------------------------------------------------------------------------------------
//  Calculates the bayer dither pattern that's used to jitter
//  the direction of the AO samples per pixel.
//------------------------------------------------------------------------------------------
float GetBayerFromCoordLevel(float2 pixelpos)
{
    float finalBayer = 0.0;

    for(float i = 1-iMXAOBayerDitherLevel; i<= 0; i++)
    {
        float bayerSize = exp2(i);
        float2 bayerCoord = floor(pixelpos * bayerSize) % 2.0;
        float bayer = 2.0 * bayerCoord.x - 4.0 * bayerCoord.x * bayerCoord.y + 3.0 * bayerCoord.y;
        finalBayer += exp2(2.0*(i+iMXAOBayerDitherLevel))* bayer;
    }

    float finalDivisor = 4.0 * exp2(2.0 * iMXAOBayerDitherLevel)- 4.0;
    //raising all values by increment is false but in AO pass it makes sense. Can you see it?
    return finalBayer/ finalDivisor + 1.0/exp2(2.0 * iMXAOBayerDitherLevel);
}


PixelType1 PixelShaderFunctionAO(PSInput PS)
{
    PixelType1 Output;
	
    // calculate projection inverse matrix
    float4x4 sProjectionInverse = inverseMatrix(gProjection);
	
    float3 viewPos = VSPositionFromDepth(PS.TexCoord.xy, sProjectionInverse);
    float4 worldPos = mul(float4(viewPos.xyz, 1), gViewInverse);
	
    float camDist = distance( gCameraPosition, worldPos.xyz ) / Linearize(1);

    float3 ScreenSpaceNormals = GetNormalFromDepth(PS.TexCoord.xy);
    ScreenSpaceNormals.y = - ScreenSpaceNormals.y;

    float radiusJitter	= GetBayerFromCoordLevel(PS.PixPos.xy);

    float3 ScreenSpacePosition = GetPosition(PS.TexCoord.xy);

    float scenedepth = ScreenSpacePosition.z / Linearize(1);
    ScreenSpacePosition += ScreenSpaceNormals * scenedepth;

    float SampleRadiusScaled  = 0.2 * fMXAOSampleRadius * fMXAOSampleRadius / (iMXAOSampleCount * ScreenSpacePosition.z);
    float mipFactor = SampleRadiusScaled * 3200.0;

    float2 currentVector;
    sincos(2.0*3.14159274*radiusJitter, currentVector.y, currentVector.x);
    static const float fNegInvR2 = -1.0 / (fMXAOSampleRadius * fMXAOSampleRadius);
    currentVector *= SampleRadiusScaled;			  
			  
    float AO = 0.0;
    float2 currentOffset;

    for(int iSample=0; iSample < iMXAOSampleCount; iSample++)
    {
        currentVector = mul(currentVector.xy, float2x2(0.575, 0.81815, -0.81815, 0.575));
        currentOffset = PS.TexCoord.xy + currentVector.xy * float2(1.0, sAspectRatio) * (iSample + radiusJitter);

        float mipLevel = saturate(log2(mipFactor * iSample) * 0.2 - 0.6) * 5.0;
		
        float3 posLod = GetPosition(currentOffset.xy);
        float3 occlVec = -ScreenSpacePosition + posLod;

        float  occlDistanceRcp 	= rsqrt(dot(occlVec, occlVec));
        float  occlAngle = dot(occlVec, ScreenSpaceNormals) * occlDistanceRcp;

        float fAO = saturate(1.0 + fNegInvR2 / occlDistanceRcp)  * saturate(occlAngle - fMXAONormalBias);

        AO += fAO;
    }

    float res = saturate(AO/(0.4 * (1.0 - fMXAONormalBias)*iMXAOSampleCount * sqrt(fMXAOSampleRadius)));			  
		  
    res = pow(abs(res), 1.0 / AO_BLUR_GAMMA);
	
    float Color = tex2D(SamplerColor, PS.TexCoord.xy).x;
    res = saturate(1  - 1.7 * res) * Color;	
	
    Output.Color = float4(res, camDist, 0, 1);
    Output.World = 0;
    return Output;
}

/* Calculates weights for bilateral AO blur. Using only
   depth is surely faster but it doesn't really cut it, also
   areas with a flat angle to the camera will have high depth
   differences, hence blur will cause stripes as seen in many
   AO implementations, even HBAO+. Taking view angle into
   account greatly helps to reduce these problems. */
float GetBlurWeight(float4 tempKey, float4 centerKey, float surfacealignment)
{
    float depthdiff = abs(tempKey.w-centerKey.w) * Linearize(1);
    float normaldiff = 1 - saturate(dot(normalize(tempKey.xyz),normalize(centerKey.xyz)));

    float depthweight = saturate(rcp(fMXAOBlurSharpness*depthdiff*5.0*surfacealignment));
    float normalweight = saturate(rcp(fMXAOBlurSharpness*normaldiff*10.0));
	
    return min(normalweight,depthweight);
}

PixelType1 PixelShaderFunctionBlur1(PSInput PS)
{
    PixelType1 Output;

    float4 tempsample;
    float4 centerkey , tempkey;
    float  centerweight, tempweight;
    float surfacealignment;
    float4 blurcoord = 0.0;
    float AO = 0.0;
	
    float3 normalTex = tex2D(SamplerNormal, PS.TexCoord.xy).xyz;
    float3 ScreenSpaceNormals = (normalTex - 0.5) * 2;
	
    float camDist = tex2D(SamplerColor, PS.TexCoord.xy).y;

    float LinearDepth = Linearize(FetchDepthBufferValue(PS.TexCoord.xy)) / Linearize(1);

    centerkey = float4(ScreenSpaceNormals, LinearDepth);
    centerweight  = 0.5;
    AO = tex2D(SamplerColor, PS.TexCoord.xy).x * 0.5;
    surfacealignment = saturate(-dot(centerkey.xyz, normalize(float3(PS.TexCoord.xy * 2.0 - 1.0, 1.0) * centerkey.w)));

    for(int orientation=-1; orientation<=1; orientation+=2)
    {
        for(float iStep = 1.0; iStep <= fMXAOBlurSteps; iStep++)
        {
            blurcoord.xy = (2.0 * iStep - 0.5) * orientation * float2(1.0,0.0) * sPixelSize + PS.TexCoord.xy;
					
            tempsample.xyz = (tex2D(SamplerNormal, blurcoord.xy).xyz - 0.5) * 2;

            tempsample.w = tex2D(SamplerColor, blurcoord.xy).x;
            float blurDepth = Linearize(FetchDepthBufferValue(blurcoord.xy)) / Linearize(1);
            tempkey = float4(tempsample.xyz, blurDepth);
            tempweight = GetBlurWeight(tempkey, centerkey, surfacealignment);
            AO += tempsample.w * tempweight;
            centerweight   += tempweight;
        }
    }

    Output.Color = float4(AO / centerweight, camDist, 0, 1);
    Output.World = float4(0, 0, 0, 0);

    return Output;
}

//------------------------------------------------------------------------------------------
// MTAApplyFog
//------------------------------------------------------------------------------------------
float3 MTAApplyFog( float3 texel, float camDist )
{
    float FogAmount = ( camDist - gFogStart )/( gFogEnd - gFogStart );
    texel.rgb = lerp(texel.rgb, gFogColor.rgb, saturate( FogAmount ) );
    return texel;
}

float3 WorldDiffuse = float3(0,0,0);

float4 PixelShaderFunctionBlur2(PSInput PS) : COLOR0
{
    float Depth = FetchDepthBufferValue(PS.TexCoord);
    if (Depth > 0.99999) return 0;
	
    float4 tempsample;
    float4 centerkey , tempkey;
    float  centerweight, tempweight;
    float surfacealignment;
    float4 blurcoord = 0.0;
    float AO  = 0.0;

    float3 ScreenSpaceNormals = (tex2D(SamplerNormal, PS.TexCoord.xy).xyz - 0.5) * 2;
	
    float LinearDepth = Linearize(Depth) / Linearize(1);

    centerkey = float4(ScreenSpaceNormals, LinearDepth);
    centerweight  = 0.5;
    AO = tex2D(SamplerColor,PS.TexCoord.xy).x * 0.5;
    surfacealignment = saturate(-dot(centerkey.xyz, normalize(float3(PS.TexCoord.xy * 2.0 - 1.0, 1.0)*centerkey.w)));

    for(int orientation=-1; orientation<=1; orientation+=2)
    {
        for(float iStep = 1.0; iStep <= fMXAOBlurSteps; iStep++)
        {
            blurcoord.xy = (2.0 * iStep - 0.5) * orientation * float2(0.0,1.0) * sPixelSize + PS.TexCoord.xy;
			
            tempsample.xyz = (tex2D(SamplerNormal, blurcoord.xy).xyz - 0.5) * 2;
			
            tempsample.w = tex2D(SamplerColor, blurcoord.xy).x;
            float blurDepth = Linearize(FetchDepthBufferValue(blurcoord.xy))/ Linearize(1);
            tempkey = float4(tempsample.xyz, blurDepth);
            tempweight = GetBlurWeight(tempkey, centerkey, surfacealignment);
            AO += tempsample.w * tempweight;
            centerweight   += tempweight;
        }
    }

    AO = pow(AO / centerweight,AO_BLUR_GAMMA);

    AO = 1.0-pow(1.0-AO, fMXAOAmbientOcclusionAmount*4.0);

    float fadeStart = min(fMXAOFadeoutStart, gFogStart / Linearize(1));
    AO = lerp(AO, 0.0,smoothstep(fadeStart, fMXAOFadeoutEnd, LinearDepth));

    float GI = AO;
    GI = max(0.0,1-GI);
	
    float camDist = tex2D(SamplerColor, PS.TexCoord.xy).y;
    float3 aoColor = MTAApplyFog(float3(0, 0, 0), camDist * Linearize(1));

    float FogAmount = 1 - saturate(2 * ( Linearize(Depth) - gFogStart )/( gFogEnd - gFogStart ));

    float4 Color;

    Color = float4(0,0,0,GI);

    return Color*PS.Diffuse;
	
//float3 norm = tex2D(SamplerNormal, PS.TexCoord.xy).xyz;
//return float4(norm, 1);
}

//--------------------------------------------------------------------------------------
// Techniques
//--------------------------------------------------------------------------------------
technique dxDrawMaterial2DShadowMapping
{
  pass P0
  {
    ZEnable = false;
    ZWriteEnable = false;
    CullMode = 2;
    ShadeMode = Gouraud;
    AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;
    AlphaTestEnable = false;
    AlphaRef = 1;
    AlphaFunc = GreaterEqual;
    Lighting = false;
    FogEnable = false;
    VertexShader = compile vs_3_0 VertexShaderFunction();
    PixelShader  = compile ps_3_0 PixelShaderFunctionShadow();
  }
  pass P1
  {
    ZEnable = false;
    ZWriteEnable = false;
    CullMode = 2;
    ShadeMode = Gouraud;
    AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;
    AlphaTestEnable = false;
    AlphaRef = 1;
    AlphaFunc = GreaterEqual;
    Lighting = false;
    FogEnable = false;
    VertexShader = compile vs_3_0 VertexShaderFunction();
    PixelShader  = compile ps_3_0 PixelShaderFunctionAO();
  }
  pass P2
  {
    ZEnable = false;
    ZWriteEnable = false;
    CullMode = 2;
    ShadeMode = Gouraud;
    AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;
    AlphaTestEnable = false;
    AlphaRef = 1;
    AlphaFunc = GreaterEqual;
    Lighting = false;
    FogEnable = false;
    VertexShader = compile vs_3_0 VertexShaderFunction();
    PixelShader  = compile ps_3_0 PixelShaderFunctionBlur1();
  }
  pass P3
  {
    ZEnable = false;
    ZWriteEnable = false;
    CullMode = 2;
    ShadeMode = Gouraud;
    AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;
    AlphaTestEnable = true;
    AlphaRef = 1;
    AlphaFunc = GreaterEqual;
    Lighting = false;
    FogEnable = false;
    VertexShader = compile vs_3_0 VertexShaderFunction();
    PixelShader  = compile ps_3_0 PixelShaderFunctionBlur2();
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
	
