/*////////////////////////////////////////////////////////////
This is a per-fragment shader for the SMF format.
It draws an animated and shaded model. Shading is done
per fragment, giving it optimal aesthetics at the cost
of performance.
////////////////////////////////////////////////////////////*/
attribute vec3 in_Position;                // (x,y,z)
attribute vec3 in_Normal;                  // (x,y,z)    
attribute vec2 in_TextureCoord;            // (u,v)
attribute vec4 in_Colour;                  // (r, g, b, a) tangent
attribute vec4 in_Colour2;                 // (bone1, bone2, bone3, bone4)
attribute vec4 in_Colour3;                 // (weight1, weight2, weight3, weight4)

varying vec2 v_vTexcoord;
varying vec3 v_vEyeVec;
varying vec3 v_vNormal;
varying vec3 v_vPos;
varying float v_vOutline;

const int maxBones = 32;
uniform vec4 boneDQ[2*maxBones];
uniform int animate;
//Outline
uniform float outlineThickness;
//Texture UVs
uniform vec4 texUVs;
//Camera position
uniform vec3 camPos;

void main()
{
    vec3 WorldCameraPos = camPos;
    vec3 newPosition = in_Position;
    vec3 newNormal = in_Normal;
    vec3 hardNormal = in_Colour.xyz * 2.0 - 1.0;
    
    if (animate == 1)
    {
        //Blend bones
        ivec4 bone = ivec4(in_Colour2 * 510.0);
        vec4 weight = in_Colour3;
        vec4 blendReal = boneDQ[bone[0]] * weight[0] + boneDQ[bone[1]] * weight[1] + boneDQ[bone[2]] * weight[2] + boneDQ[bone[3]] * weight[3];
        vec4 blendDual = boneDQ[bone[0]+1] * weight[0] + boneDQ[bone[1]+1] * weight[1] + boneDQ[bone[2]+1] * weight[2] + boneDQ[bone[3]+1] * weight[3];
        //Normalize resulting dual quaternion
        float blendNormReal = 1.0 / length(blendReal);
        blendReal *= blendNormReal;
        blendDual = (blendDual - blendReal * dot(blendReal, blendDual)) * blendNormReal;

        //Transform vertex
        /*Rotation*/    newPosition += 2.0 * cross(blendReal.xyz, cross(blendReal.xyz, newPosition) + blendReal.w * newPosition);
        /*Translation*/    newPosition += 2.0 * (blendReal.w * blendDual.xyz - blendDual.w * blendReal.xyz + cross(blendReal.xyz, blendDual.xyz));
        /*Normal*/        newNormal += 2.0 * cross(blendReal.xyz, cross(blendReal.xyz, newNormal) + blendReal.w * newNormal);
        /*Normal*/        hardNormal += 2.0 * cross(blendReal.xyz, cross(blendReal.xyz, hardNormal) + blendReal.w * hardNormal);
    }
    
    vec4 objectSpacePos = vec4(newPosition, 1.0);
    
    //Varying variables
    v_vNormal = mat3(gm_Matrices[MATRIX_WORLD]) * newNormal;
    v_vTexcoord = texUVs.xy + vec2(texUVs.z, texUVs.w) * in_TextureCoord;
    v_vPos = vec3(gm_Matrices[MATRIX_WORLD] * objectSpacePos);
    v_vEyeVec = WorldCameraPos - v_vPos;
    
    v_vOutline = 0.0;
    vec3 WorldHardNormal = normalize((gm_Matrices[MATRIX_WORLD] * vec4(hardNormal, 0.0)).xyz);
    if (dot(WorldHardNormal, v_vEyeVec) < 0.0)
    {
        vec4 tempPos = gm_Matrices[MATRIX_WORLD_VIEW] * objectSpacePos;
        objectSpacePos.xyz += 2.0 * newNormal * tempPos.z * outlineThickness;
        v_vOutline = 1.0;
    }
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * objectSpacePos;
}
