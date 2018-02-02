// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Forceling/TerrainFirstPass"
{
	Properties
	{
		_TessValue( "Max Tessellation", Range( 1, 32 ) ) = 15
		_TessMin( "Tess Min Distance", Float ) = 2
		_TessMax( "Tess Max Distance", Float ) = 25
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
		_Displ1Intensity("Displ1 Intensity", Range( 0 , 5)) = 0
		_Displ2Intensity("Displ2 Intensity", Range( 0 , 5)) = 0
		_Displ4Intensity("Displ4 Intensity", Range( 0 , 5)) = 0
		_Displ3Intensity("Displ3 Intensity", Range( 0 , 5)) = 0
		_Displacement2("Displacement2", 2D) = "bump" {}
		_Displacement3("Displacement3", 2D) = "bump" {}
		_Displacement0("Displacement0", 2D) = "bump" {}
		_Displacement1("Displacement1", 2D) = "bump" {}
		_Emissive1("Emissive1", 2D) = "black" {}
		_Emissive0("Emissive0", 2D) = "black" {}
		_WaterColor("Water Color", Color) = (1,1,1,0)
		_WaterSmoothness("Water Smoothness", Float) = 1
		_DisplIntensity("Displ Intensity", Range( 0 , 1)) = 0
		_WetnessOffset("Wetness Offset", Range( -10 , 10)) = 0.4090774
		_SnowOffset("Snow Offset", Range( -10 , 0)) = 0
		_WetnessStrength("Wetness Strength", Range( 0 , 5)) = 5
		_SnowStrength("Snow Strength", Range( 0 , 5)) = 5
		_SnowColor("Snow Color", Color) = (0.8014706,0.8932049,1,0)
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
		uniform float4 _SnowColor;
		uniform float _SnowStrength;
		uniform float _SnowOffset;
		uniform float4 _WaterColor;
		uniform float _WetnessStrength;
		uniform float _WetnessOffset;
		uniform sampler2D _Emissive0;
		uniform sampler2D _Emissive1;
		uniform float _Metallic;
		uniform float _Smoothness;
		uniform float _WaterSmoothness;
		uniform sampler2D _Displacement0;
		uniform float _Displ1Intensity;
		uniform sampler2D _Displacement1;
		uniform float _Displ2Intensity;
		uniform sampler2D _Displacement2;
		uniform float _Displ3Intensity;
		uniform sampler2D _Displacement3;
		uniform float _Displ4Intensity;
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
			float4 tex2DNode5_g11 = tex2Dlod( _Control, float4( uv_Control, 0, 0.0) );
			float dotResult20_g11 = dot( tex2DNode5_g11 , float4(1,1,1,1) );
			float SplatWeight22_g11 = dotResult20_g11;
			float4 SplatControl26_g11 = ( tex2DNode5_g11 / ( SplatWeight22_g11 + 0.001 ) );
			float4 temp_output_59_0_g11 = SplatControl26_g11;
			float2 uv_Splat0 = v.texcoord.xy * _Splat0_ST.xy + _Splat0_ST.zw;
			float2 uv_Splat1 = v.texcoord.xy * _Splat1_ST.xy + _Splat1_ST.zw;
			float2 uv_Splat2 = v.texcoord.xy * _Splat2_ST.xy + _Splat2_ST.zw;
			float2 uv_Splat3 = v.texcoord.xy * _Splat3_ST.xy + _Splat3_ST.zw;
			float4 weightedBlendVar82_g11 = temp_output_59_0_g11;
			float weightedBlend82_g11 = ( weightedBlendVar82_g11.x*( tex2Dlod( _Displacement0, float4( uv_Splat0, 0, 0.0) ).r * _Displ1Intensity ) + weightedBlendVar82_g11.y*( tex2Dlod( _Displacement1, float4( uv_Splat1, 0, 0.0) ).r * _Displ2Intensity ) + weightedBlendVar82_g11.z*( tex2Dlod( _Displacement2, float4( uv_Splat2, 0, 0.0) ).r * _Displ3Intensity ) + weightedBlendVar82_g11.w*( tex2Dlod( _Displacement3, float4( uv_Splat3, 0, 0.0) ).r * _Displ4Intensity ) );
			float3 temp_cast_2 = (( weightedBlend82_g11 * _DisplIntensity )).xxx;
			v.vertex.xyz += temp_cast_2;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Control = i.uv_texcoord * _Control_ST.xy + _Control_ST.zw;
			float4 tex2DNode5_g11 = tex2D( _Control, uv_Control );
			float dotResult20_g11 = dot( tex2DNode5_g11 , float4(1,1,1,1) );
			float SplatWeight22_g11 = dotResult20_g11;
			float4 SplatControl26_g11 = ( tex2DNode5_g11 / ( SplatWeight22_g11 + 0.001 ) );
			float4 temp_output_59_0_g11 = SplatControl26_g11;
			float2 uv_Splat0 = i.uv_texcoord * _Splat0_ST.xy + _Splat0_ST.zw;
			float2 uv_Splat1 = i.uv_texcoord * _Splat1_ST.xy + _Splat1_ST.zw;
			float2 uv_Splat2 = i.uv_texcoord * _Splat2_ST.xy + _Splat2_ST.zw;
			float2 uv_Splat3 = i.uv_texcoord * _Splat3_ST.xy + _Splat3_ST.zw;
			float4 weightedBlendVar8_g11 = temp_output_59_0_g11;
			float4 weightedBlend8_g11 = ( weightedBlendVar8_g11.x*tex2D( _Normal0, uv_Splat0 ) + weightedBlendVar8_g11.y*tex2D( _Normal1, uv_Splat1 ) + weightedBlendVar8_g11.z*tex2D( _Normal2, uv_Splat2 ) + weightedBlendVar8_g11.w*tex2D( _Normal3, uv_Splat3 ) );
			o.Normal = UnpackNormal( weightedBlend8_g11 );
			float4 appendResult33_g11 = (float4(1.0 , 1.0 , 1.0 , _Smoothness0));
			float4 appendResult36_g11 = (float4(1.0 , 1.0 , 1.0 , _Smoothness1));
			float4 appendResult39_g11 = (float4(1.0 , 1.0 , 1.0 , _Smoothness2));
			float4 appendResult42_g11 = (float4(1.0 , 1.0 , 1.0 , _Smoothness3));
			float4 weightedBlendVar9_g11 = temp_output_59_0_g11;
			float4 weightedBlend9_g11 = ( weightedBlendVar9_g11.x*( appendResult33_g11 * tex2D( _Splat0, uv_Splat0 ) ) + weightedBlendVar9_g11.y*( appendResult36_g11 * tex2D( _Splat1, uv_Splat1 ) ) + weightedBlendVar9_g11.z*( appendResult39_g11 * tex2D( _Splat2, uv_Splat2 ) ) + weightedBlendVar9_g11.w*( appendResult42_g11 * tex2D( _Splat3, uv_Splat3 ) ) );
			float4 MixDiffuse28_g11 = weightedBlend9_g11;
			float3 ase_worldPos = i.worldPos;
			float clampResult15 = clamp( ( ( ase_worldPos.y * _SnowStrength ) + _SnowOffset ) , 0.0 , 1.0 );
			float4 lerpResult7 = lerp( MixDiffuse28_g11 , _SnowColor , clampResult15);
			float clampResult50 = clamp( -( ( ase_worldPos.y * _WetnessStrength ) + _WetnessOffset ) , 0.0 , 1.0 );
			float4 lerpResult33 = lerp( lerpResult7 , ( lerpResult7 * _WaterColor ) , clampResult50);
			o.Albedo = lerpResult33.rgb;
			float4 weightedBlendVar88_g11 = temp_output_59_0_g11;
			float4 weightedBlend88_g11 = ( weightedBlendVar88_g11.x*tex2D( _Emissive0, uv_Splat0 ) + weightedBlendVar88_g11.y*tex2D( _Emissive1, uv_Splat1 ) + weightedBlendVar88_g11.z*float4( 0,0,0,0 ) + weightedBlendVar88_g11.w*float4( 0,0,0,0 ) );
			o.Emission = weightedBlend88_g11.rgb;
			o.Metallic = _Metallic;
			float lerpResult26 = lerp( _Smoothness , _WaterSmoothness , clampResult50);
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
0;534;1599;484;3872.982;813.9169;3.164843;True;False
Node;AmplifyShaderEditor.WorldPosInputsNode;14;-2108.053,-624.7399;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;16;-2122.524,-454.0021;Float;False;Property;_SnowStrength;Snow Strength;39;0;Create;True;5;0;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-2105.135,-343.3751;Float;False;Property;_SnowOffset;Snow Offset;37;0;Create;True;0;0;-10;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-1815.773,-537.9241;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-553.5073,-886.7032;Float;False;Property;_WetnessStrength;Wetness Strength;38;0;Create;True;5;0;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;30;-684.6371,-1066.541;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;27;-316.8628,-777.9749;Float;False;Property;_WetnessOffset;Wetness Offset;36;0;Create;True;0.4090774;0;-10;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;11;-1603.523,-429.086;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-246.7569,-970.6253;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;15;-1413.138,-437.323;Float;True;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;13;-1612.559,-740.9682;Float;False;Property;_SnowColor;Snow Color;40;0;Create;True;0.8014706,0.8932049,1,0;0.8014706,0.8932049,1,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;74;-1394.69,-30.37831;Float;False;Forceling_Four Splats First Pass Terrain 1;5;;11;7dd07606af44c854498b49f0cfe9b50d;0;8;89;FLOAT3;0,0,0;False;84;FLOAT;0.0;False;59;FLOAT4;0,0,0,0;False;60;FLOAT4;0,0,0,0;False;61;FLOAT3;0,0,0;False;57;FLOAT;0.0;False;58;FLOAT;0.0;False;62;FLOAT;0.0;False;8;FLOAT3;90;FLOAT;83;FLOAT4;0;FLOAT3;14;FLOAT;56;FLOAT;45;FLOAT;19;FLOAT;17
Node;AmplifyShaderEditor.SimpleAddOpNode;28;-9.401917,-904.1357;Float;True;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;38;273.157,-914.4269;Float;True;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;52;-192.4733,-557.2051;Float;False;Property;_WaterColor;Water Color;33;0;Create;True;1,1,1,0;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;7;-595.058,-435.7805;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-1313.576,718.2017;Float;False;Property;_DisplIntensity;Displ Intensity;35;0;Create;True;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;117.8081,-385.2879;Float;False;2;2;0;COLOR;0.0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;50;402.3418,-592.5757;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;34;190.9159,267.3154;Float;False;Property;_WaterSmoothness;Water Smoothness;34;0;Create;True;1;0;1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-537.7977,196.146;Float;False;Property;_Smoothness;Smoothness;41;0;Create;True;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;26;617.0953,197.2251;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0;False;2;FLOAT;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-744.0955,532.2336;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;33;565.6143,-118.3741;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;2;-536.4975,122.046;Float;False;Property;_Metallic;Metallic;42;0;Create;True;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1885.157,-30.73383;Float;False;True;6;Float;ASEMaterialInspector;0;0;Standard;Forceling/TerrainFirstPass;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;False;0;Opaque;0.5;True;True;-100;False;Opaque;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;True;0;15;2;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;0;0;1;SplatCount=4;0;False;1;BaseMapShader=ASESampleShaders/SimpleTerrainBase;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;17;0;14;2
WireConnection;17;1;16;0
WireConnection;11;0;17;0
WireConnection;11;1;9;0
WireConnection;31;0;30;2
WireConnection;31;1;29;0
WireConnection;15;0;11;0
WireConnection;28;0;31;0
WireConnection;28;1;27;0
WireConnection;38;0;28;0
WireConnection;7;0;74;0
WireConnection;7;1;13;0
WireConnection;7;2;15;0
WireConnection;51;0;7;0
WireConnection;51;1;52;0
WireConnection;50;0;38;0
WireConnection;26;0;3;0
WireConnection;26;1;34;0
WireConnection;26;2;50;0
WireConnection;22;0;74;83
WireConnection;22;1;21;0
WireConnection;33;0;7;0
WireConnection;33;1;51;0
WireConnection;33;2;50;0
WireConnection;0;0;33;0
WireConnection;0;1;74;14
WireConnection;0;2;74;90
WireConnection;0;3;2;0
WireConnection;0;4;26;0
WireConnection;0;11;22;0
ASEEND*/
//CHKSM=6D21162DBA2EB1324DBC41FE04F0B0BF6618E720