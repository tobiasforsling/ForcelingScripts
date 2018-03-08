// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Forceling/TerrainFirstPass"
{
	Properties
	{
		_TessValue( "Max Tessellation", Range( 1, 32 ) ) = 32
		_TessMin( "Tess Min Distance", Float ) = 0.64
		_TessMax( "Tess Max Distance", Float ) = 8.81
		_DisplIntensity("Displ Intensity", Range( 0 , 1)) = 0
		[Header(Forceling_Four Splats First Pass Terrain 1)]
		[HideInInspector]_Control("Control", 2D) = "white" {}
		[HideInInspector]_Splat3("Splat3", 2D) = "white" {}
		[HideInInspector]_Splat2("Splat2", 2D) = "white" {}
		[HideInInspector]_Splat1("Splat1", 2D) = "white" {}
		[HideInInspector]_Splat0("Splat0", 2D) = "white" {}
		[HideInInspector]_Normal0("Normal0", 2D) = "white" {}
		[HideInInspector]_Normal1("Normal1", 2D) = "white" {}
		[HideInInspector]_Normal2("Normal2", 2D) = "white" {}
		[HideInInspector]_Normal3("Normal3", 2D) = "white" {}
		[HideInInspector]_Smoothness3("Smoothness3", Range( 0 , 1)) = 1
		[HideInInspector]_Smoothness1("Smoothness1", Range( 0 , 1)) = 1
		[HideInInspector]_Smoothness0("Smoothness0", Range( 0 , 1)) = 1
		[HideInInspector]_Smoothness2("Smoothness2", Range( 0 , 1)) = 1
		_Displ0Intensity("Displ0 Intensity", Range( 0 , 20)) = 0
		_Displ1Intensity("Displ1 Intensity", Range( 0 , 20)) = 0
		_Displ3Intensity("Displ3 Intensity", Range( 0 , 20)) = 0
		_Displ2Intensity("Displ2 Intensity", Range( 0 , 20)) = 0
		_Displacement2("Displacement2", 2D) = "bump" {}
		_Displacement3("Displacement3", 2D) = "bump" {}
		_Displacement0("Displacement0", 2D) = "bump" {}
		_Displacement1("Displacement1", 2D) = "bump" {}
		_Emissive1("Emissive1", 2D) = "black" {}
		_Emissive0("Emissive0", 2D) = "black" {}
		_SnowAlbedo("Snow Albedo", 2D) = "white" {}
		_SnowMS("Snow M/S", 2D) = "white" {}
		_SnowMask("Snow Mask", 2D) = "black" {}
		_WetColor("Wet Color", Color) = (1,1,1,0)
		_WetSmoothness("Wet Smoothness", Float) = 1
		_WetnessOffset("Wetness Offset", Range( -10 , 10)) = 0.4090774
		_WetnessStrength("Wetness Strength", Range( 0 , 5)) = 5
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		_Metallic("Metallic", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry-100" "IsEmissive" = "true"  "SplatCount"="4" }
		Cull Back
		CGPROGRAM
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform sampler2D _Control;
		uniform float4 _Control_ST;
		uniform sampler2D _Normal0;
		uniform sampler2D _Splat0;
		uniform float4 _Splat0_ST;
		uniform sampler2D _Normal1;
		uniform sampler2D _Splat1;
		uniform float4 _Splat1_ST;
		uniform sampler2D _Normal2;
		uniform sampler2D _Splat2;
		uniform float4 _Splat2_ST;
		uniform sampler2D _Normal3;
		uniform sampler2D _Splat3;
		uniform float4 _Splat3_ST;
		uniform float _Smoothness0;
		uniform float _Smoothness1;
		uniform float _Smoothness2;
		uniform float _Smoothness3;
		uniform sampler2D _SnowAlbedo;
		uniform float4 _SnowAlbedo_ST;
		uniform sampler2D _SnowMask;
		uniform float4 _SnowMask_ST;
		uniform float4 _WetColor;
		uniform float _WetnessStrength;
		uniform float _WetnessOffset;
		uniform sampler2D _Emissive0;
		uniform sampler2D _Emissive1;
		uniform float _Metallic;
		uniform float _Smoothness;
		uniform sampler2D _SnowMS;
		uniform float4 _SnowMS_ST;
		uniform float _WetSmoothness;
		uniform sampler2D _Displacement0;
		uniform float _Displ0Intensity;
		uniform sampler2D _Displacement1;
		uniform float _Displ1Intensity;
		uniform sampler2D _Displacement2;
		uniform float _Displ2Intensity;
		uniform sampler2D _Displacement3;
		uniform float _Displ3Intensity;
		uniform float _DisplIntensity;
		uniform float _TessValue;
		uniform float _TessMin;
		uniform float _TessMax;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityDistanceBasedTess( v0.vertex, v1.vertex, v2.vertex, _TessMin, _TessMax, _TessValue );
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float2 uv_Control = v.texcoord * _Control_ST.xy + _Control_ST.zw;
			float4 tex2DNode5_g13 = tex2Dlod( _Control, float4( uv_Control, 0, 0.0) );
			float dotResult20_g13 = dot( tex2DNode5_g13 , float4(1,1,1,1) );
			float SplatWeight22_g13 = dotResult20_g13;
			float4 SplatControl26_g13 = ( tex2DNode5_g13 / ( SplatWeight22_g13 + 0.001 ) );
			float4 temp_output_59_0_g13 = SplatControl26_g13;
			float2 uv_Splat0 = v.texcoord.xy * _Splat0_ST.xy + _Splat0_ST.zw;
			float2 uv_Splat1 = v.texcoord.xy * _Splat1_ST.xy + _Splat1_ST.zw;
			float2 uv_Splat2 = v.texcoord.xy * _Splat2_ST.xy + _Splat2_ST.zw;
			float2 uv_Splat3 = v.texcoord.xy * _Splat3_ST.xy + _Splat3_ST.zw;
			float4 weightedBlendVar82_g13 = temp_output_59_0_g13;
			float weightedBlend82_g13 = ( weightedBlendVar82_g13.x*( tex2Dlod( _Displacement0, float4( uv_Splat0, 0, 0.0) ).r * _Displ0Intensity ) + weightedBlendVar82_g13.y*( tex2Dlod( _Displacement1, float4( uv_Splat1, 0, 0.0) ).r * _Displ1Intensity ) + weightedBlendVar82_g13.z*( tex2Dlod( _Displacement2, float4( uv_Splat2, 0, 0.0) ).r * _Displ2Intensity ) + weightedBlendVar82_g13.w*( tex2Dlod( _Displacement3, float4( uv_Splat3, 0, 0.0) ).r * _Displ3Intensity ) );
			float4 appendResult77 = (float4(0.0 , ( weightedBlend82_g13 * _DisplIntensity ) , 0.0 , 0.0));
			v.vertex.xyz += appendResult77.xyz;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Control = i.uv_texcoord * _Control_ST.xy + _Control_ST.zw;
			float4 tex2DNode5_g13 = tex2D( _Control, uv_Control );
			float dotResult20_g13 = dot( tex2DNode5_g13 , float4(1,1,1,1) );
			float SplatWeight22_g13 = dotResult20_g13;
			float4 SplatControl26_g13 = ( tex2DNode5_g13 / ( SplatWeight22_g13 + 0.001 ) );
			float4 temp_output_59_0_g13 = SplatControl26_g13;
			float2 uv_Splat0 = i.uv_texcoord * _Splat0_ST.xy + _Splat0_ST.zw;
			float2 uv_Splat1 = i.uv_texcoord * _Splat1_ST.xy + _Splat1_ST.zw;
			float2 uv_Splat2 = i.uv_texcoord * _Splat2_ST.xy + _Splat2_ST.zw;
			float2 uv_Splat3 = i.uv_texcoord * _Splat3_ST.xy + _Splat3_ST.zw;
			float4 weightedBlendVar8_g13 = temp_output_59_0_g13;
			float4 weightedBlend8_g13 = ( weightedBlendVar8_g13.x*tex2D( _Normal0, uv_Splat0 ) + weightedBlendVar8_g13.y*tex2D( _Normal1, uv_Splat1 ) + weightedBlendVar8_g13.z*tex2D( _Normal2, uv_Splat2 ) + weightedBlendVar8_g13.w*tex2D( _Normal3, uv_Splat3 ) );
			o.Normal = UnpackNormal( weightedBlend8_g13 );
			float4 appendResult33_g13 = (float4(1.0 , 1.0 , 1.0 , _Smoothness0));
			float4 appendResult36_g13 = (float4(1.0 , 1.0 , 1.0 , _Smoothness1));
			float4 appendResult39_g13 = (float4(1.0 , 1.0 , 1.0 , _Smoothness2));
			float4 appendResult42_g13 = (float4(1.0 , 1.0 , 1.0 , _Smoothness3));
			float4 weightedBlendVar9_g13 = temp_output_59_0_g13;
			float4 weightedBlend9_g13 = ( weightedBlendVar9_g13.x*( appendResult33_g13 * tex2D( _Splat0, uv_Splat0 ) ) + weightedBlendVar9_g13.y*( appendResult36_g13 * tex2D( _Splat1, uv_Splat1 ) ) + weightedBlendVar9_g13.z*( appendResult39_g13 * tex2D( _Splat2, uv_Splat2 ) ) + weightedBlendVar9_g13.w*( appendResult42_g13 * tex2D( _Splat3, uv_Splat3 ) ) );
			float4 MixDiffuse28_g13 = weightedBlend9_g13;
			float2 uv_SnowAlbedo = i.uv_texcoord * _SnowAlbedo_ST.xy + _SnowAlbedo_ST.zw;
			float2 uv_SnowMask = i.uv_texcoord * _SnowMask_ST.xy + _SnowMask_ST.zw;
			float4 tex2DNode80 = tex2D( _SnowMask, uv_SnowMask );
			float4 lerpResult7 = lerp( MixDiffuse28_g13 , tex2D( _SnowAlbedo, uv_SnowAlbedo ) , tex2DNode80.r);
			float3 ase_worldPos = i.worldPos;
			float clampResult50 = clamp( -( ( ase_worldPos.y * _WetnessStrength ) + _WetnessOffset ) , 0.0 , 1.0 );
			float4 lerpResult33 = lerp( lerpResult7 , ( lerpResult7 * _WetColor ) , clampResult50);
			o.Albedo = lerpResult33.rgb;
			float4 weightedBlendVar88_g13 = temp_output_59_0_g13;
			float4 weightedBlend88_g13 = ( weightedBlendVar88_g13.x*tex2D( _Emissive0, uv_Splat0 ) + weightedBlendVar88_g13.y*tex2D( _Emissive1, uv_Splat1 ) + weightedBlendVar88_g13.z*float4( 0,0,0,0 ) + weightedBlendVar88_g13.w*float4( 0,0,0,0 ) );
			o.Emission = weightedBlend88_g13.rgb;
			o.Metallic = _Metallic;
			float2 uv_SnowMS = i.uv_texcoord * _SnowMS_ST.xy + _SnowMS_ST.zw;
			float lerpResult86 = lerp( _Smoothness , tex2D( _SnowMS, uv_SnowMS ).a , tex2DNode80.r);
			float lerpResult26 = lerp( lerpResult86 , _WetSmoothness , clampResult50);
			o.Smoothness = lerpResult26;
			o.Alpha = 1;
		}

		ENDCG
	}

	Dependency "BaseMapShader"="ASESampleShaders/SimpleTerrainBase"
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=14301
0;534;1599;484;1876.997;561.556;2.735543;True;False
Node;AmplifyShaderEditor.WorldPosInputsNode;30;-684.6371,-1066.541;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;29;-553.5073,-886.7032;Float;False;Property;_WetnessStrength;Wetness Strength;42;0;Create;True;5;0.58;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-316.8628,-777.9749;Float;False;Property;_WetnessOffset;Wetness Offset;41;0;Create;True;0.4090774;-1.5;-10;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-246.7569,-970.6253;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;28;-9.401917,-904.1357;Float;True;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;80;-1772.711,-641.0507;Float;True;Property;_SnowMask;Snow Mask;37;0;Create;True;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;76;-1394.69,-30.37831;Float;False;Forceling_Four Splats First Pass Terrain 1;6;;13;7dd07606af44c854498b49f0cfe9b50d;0;8;89;FLOAT3;0,0,0;False;84;FLOAT;0.0;False;59;FLOAT4;0,0,0,0;False;60;FLOAT4;0,0,0,0;False;61;FLOAT3;0,0,0;False;57;FLOAT;0.0;False;58;FLOAT;0.0;False;62;FLOAT;0.0;False;8;FLOAT3;90;FLOAT;83;FLOAT4;0;FLOAT3;14;FLOAT;56;FLOAT;45;FLOAT;19;FLOAT;17
Node;AmplifyShaderEditor.SamplerNode;83;-1472.523,-1022.215;Float;True;Property;_SnowAlbedo;Snow Albedo;34;0;Create;True;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NegateNode;38;273.157,-914.4269;Float;True;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-1391.432,1212.104;Float;False;Property;_DisplIntensity;Displ Intensity;5;0;Create;True;0;0.029;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;52;-192.4733,-557.2051;Float;False;Property;_WetColor;Wet Color;39;0;Create;True;1,1,1,0;0.5220588,0.5220588,0.5220588,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;3;-1266.279,344.5599;Float;False;Property;_Smoothness;Smoothness;43;0;Create;True;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;82;-831.3745,434.6233;Float;True;Property;_SnowMS;Snow M/S;36;0;Create;True;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;7;-595.058,-435.7805;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;34;460.9806,347.6049;Float;False;Property;_WetSmoothness;Wet Smoothness;40;0;Create;True;1;1;1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-821.9523,1026.136;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;117.8081,-385.2879;Float;False;2;2;0;COLOR;0.0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;86;-206.4996,307.7881;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;50;402.3418,-592.5757;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;77;-525.3077,919.1064;Float;False;FLOAT4;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;81;-1309.252,-308.0919;Float;True;Property;_SnowNormal;Snow Normal;35;0;Create;True;None;None;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;26;694.9516,194.7921;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0;False;2;FLOAT;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2;-1264.979,270.4599;Float;False;Property;_Metallic;Metallic;44;0;Create;True;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;13;-1413.163,-811.6396;Float;False;Property;_SnowColor;Snow Color;38;0;Create;True;0.8014706,0.8932049,1,0;0.8014706,0.8932049,1,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;79;-831.3519,941.7113;Float;False;Constant;_Float1;Float 1;12;0;Create;True;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;33;565.6143,-118.3741;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1885.157,-30.73383;Float;False;True;6;Float;ASEMaterialInspector;0;0;Standard;Forceling/TerrainFirstPass;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;False;0;Opaque;0.5;True;True;-100;False;Opaque;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;True;0;32;0.64;8.81;False;0.5;True;0;Zero;Zero;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;0;0;1;SplatCount=4;0;False;1;BaseMapShader=ASESampleShaders/SimpleTerrainBase;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;31;0;30;2
WireConnection;31;1;29;0
WireConnection;28;0;31;0
WireConnection;28;1;27;0
WireConnection;38;0;28;0
WireConnection;7;0;76;0
WireConnection;7;1;83;0
WireConnection;7;2;80;1
WireConnection;22;0;76;83
WireConnection;22;1;21;0
WireConnection;51;0;7;0
WireConnection;51;1;52;0
WireConnection;86;0;3;0
WireConnection;86;1;82;4
WireConnection;86;2;80;1
WireConnection;50;0;38;0
WireConnection;77;1;22;0
WireConnection;26;0;86;0
WireConnection;26;1;34;0
WireConnection;26;2;50;0
WireConnection;33;0;7;0
WireConnection;33;1;51;0
WireConnection;33;2;50;0
WireConnection;0;0;33;0
WireConnection;0;1;76;14
WireConnection;0;2;76;90
WireConnection;0;3;2;0
WireConnection;0;4;26;0
WireConnection;0;11;77;0
ASEEND*/
//CHKSM=9E98F091E59D0D93B0997EE296BD8127B501AE6F