// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Forceling/Ghost"
{
	Properties
	{
		_GroundFade("Ground Fade", Range( 0 , 1)) = 0
		_EmissionNoise("Emission Noise", 2D) = "white" {}
		[Toggle]_UseErrorColor("Use Error Color", Float) = 0
		_OpacistyMask2("Opacisty Mask 2", 2D) = "white" {}
		_ErrorColor("Error Color", Color) = (1,0,0,0)
		_PlacingColor("Placing Color", Color) = (0.5588235,0.7261663,1,0)
		_Opacity("Opacity", Range( 0 , 1)) = 0
		_GlowPower("Glow Power", Range( 0 , 20)) = 11.60903
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityCG.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit alpha:fade keepalpha noshadow 
		struct Input
		{
			float4 screenPos;
			float2 uv_texcoord;
		};

		uniform float _UseErrorColor;
		uniform float4 _PlacingColor;
		uniform sampler2D _CameraDepthTexture;
		uniform float _GroundFade;
		uniform float4 _ErrorColor;
		uniform sampler2D _EmissionNoise;
		uniform float _GlowPower;
		uniform float _Opacity;
		uniform sampler2D _OpacistyMask2;

		inline fixed4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return fixed4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth1 = LinearEyeDepth(UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture,UNITY_PROJ_COORD(ase_screenPos))));
			float distanceDepth1 = abs( ( screenDepth1 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _GroundFade ) );
			float clampResult6 = clamp( distanceDepth1 , 0.0 , 1.0 );
			float2 uv_TexCoord82 = i.uv_texcoord * float2( 1,1 ) + float2( 0,0 );
			float2 panner81 = ( uv_TexCoord82 + 1.0 * _Time.y * float2( 0.03,0.03 ));
			float4 tex2DNode83 = tex2D( _EmissionNoise, panner81 );
			float4 blendOpSrc84 = lerp(( _PlacingColor * clampResult6 ),( _ErrorColor * clampResult6 ),_UseErrorColor);
			float4 blendOpDest84 = tex2DNode83;
			o.Emission = ( ( saturate( (( blendOpDest84 > 0.5 ) ? ( 1.0 - ( 1.0 - 2.0 * ( blendOpDest84 - 0.5 ) ) * ( 1.0 - blendOpSrc84 ) ) : ( 2.0 * blendOpDest84 * blendOpSrc84 ) ) )) * _GlowPower ).rgb;
			float4 temp_cast_1 = (clampResult6).xxxx;
			float4 blendOpSrc94 = temp_cast_1;
			float4 blendOpDest94 = tex2DNode83;
			float4 clampResult93 = clamp( (( blendOpDest94 > 0.5 ) ? ( 1.0 - ( 1.0 - 2.0 * ( blendOpDest94 - 0.5 ) ) * ( 1.0 - blendOpSrc94 ) ) : ( 2.0 * blendOpDest94 * blendOpSrc94 ) ) , float4( 0,0,0,0 ) , float4( 1,0,0,0 ) );
			float eyeDepth110 = LinearEyeDepth(UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture,UNITY_PROJ_COORD(ase_screenPos))));
			float2 uv_TexCoord118 = i.uv_texcoord * float2( 1,1 ) + float2( 0,0 );
			float2 panner119 = ( uv_TexCoord118 + 1.0 * _Time.y * float2( -0.02,-0.02 ));
			float4 clampResult115 = clamp( ( ( ( clampResult93 * _Opacity ) * abs( ( eyeDepth110 - ase_screenPos.w ) ) ) * tex2D( _OpacistyMask2, panner119 ) ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			o.Alpha = clampResult115.r;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=14001
0;640;1478;378;227.1089;-1176.938;1.019662;True;False
Node;AmplifyShaderEditor.TextureCoordinatesNode;82;-1204.168,1211.464;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;2;-1531.096,1046.75;Float;False;Property;_GroundFade;Ground Fade;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;81;-900.132,1211.612;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.03,0.03;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DepthFade;1;-1177.846,1030.809;Float;False;True;1;0;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;83;-600.8323,1184.75;Float;True;Property;_EmissionNoise;Emission Noise;4;0;Assets/Particlecollection_Free samples/Texture/airflow_04.png;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;6;-876.1086,989.3553;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;109;155.1769,279.9871;Float;False;1;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendOpsNode;94;55.31561,1160.294;Float;False;Overlay;False;2;0;FLOAT;0,0,0,0;False;1;COLOR;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScreenDepthNode;110;377.1769,277.4869;Float;False;0;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;111;584.5768,322.7872;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;118;87.28873,1485.99;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;93;338.4708,1032.821;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;79;27.98414,1359.364;Float;False;Property;_Opacity;Opacity;13;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;76;-1051.368,502.7978;Float;False;Property;_PlacingColor;Placing Color;12;0;0.5588235,0.7261663,1,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;87;-1043.295,698.597;Float;False;Property;_ErrorColor;Error Color;12;0;1,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;78;518.5845,1208.772;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PannerNode;119;391.3246,1486.138;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-0.02,-0.02;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;86;-610.6815,705.1415;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;75;-609.5624,488.047;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.AbsOpNode;112;767.7698,336.6356;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;114;688.4318,1080.62;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;85;-208.1408,625.916;Float;False;Property;_UseErrorColor;Use Error Color;5;0;0;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;116;669.7598,1336.58;Float;True;Property;_OpacistyMask2;Opacisty Mask 2;7;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;90;58.37037,887.6052;Float;False;Property;_GlowPower;Glow Power;13;0;11.60903;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;117;1004.515,1129.35;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;84;57.50066,709.4776;Float;False;Overlay;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;91;350.0328,676.8975;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;115;1082.349,904.7213;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;124;1273.682,640.066;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;Forceling/Ghost;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;Back;0;0;False;0;0;Transparent;0.5;True;False;0;False;Transparent;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;2;15;10;25;False;0.5;False;2;SrcAlpha;OneMinusSrcAlpha;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;81;0;82;0
WireConnection;1;0;2;0
WireConnection;83;1;81;0
WireConnection;6;0;1;0
WireConnection;94;0;6;0
WireConnection;94;1;83;0
WireConnection;110;0;109;0
WireConnection;111;0;110;0
WireConnection;111;1;109;4
WireConnection;93;0;94;0
WireConnection;78;0;93;0
WireConnection;78;1;79;0
WireConnection;119;0;118;0
WireConnection;86;0;87;0
WireConnection;86;1;6;0
WireConnection;75;0;76;0
WireConnection;75;1;6;0
WireConnection;112;0;111;0
WireConnection;114;0;78;0
WireConnection;114;1;112;0
WireConnection;85;0;75;0
WireConnection;85;1;86;0
WireConnection;116;1;119;0
WireConnection;117;0;114;0
WireConnection;117;1;116;0
WireConnection;84;0;85;0
WireConnection;84;1;83;0
WireConnection;91;0;84;0
WireConnection;91;1;90;0
WireConnection;115;0;117;0
WireConnection;124;2;91;0
WireConnection;124;9;115;0
ASEEND*/
//CHKSM=71757C8C4889C9BC7C07C17852690747AACBE849