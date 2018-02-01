// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Forceling/TerrainFirstPass"
{
	Properties
	{
		_TessValue( "Max Tessellation", Range( 1, 32 ) ) = 15
		_TessMin( "Tess Min Distance", Float ) = 2
		_TessMax( "Tess Max Distance", Float ) = 25
		[Header(Four Splats First Pass Terrain)]
		[HideInInspector]_Control("Control", 2D) = "white" {}
		[HideInInspector]_Splat3("Splat3", 2D) = "white" {}
		[HideInInspector]_Splat2("Splat2", 2D) = "white" {}
		[HideInInspector]_Splat1("Splat1", 2D) = "white" {}
		[HideInInspector]_Splat0("Splat0", 2D) = "white" {}
		[HideInInspector]_Normal0("Normal0", 2D) = "white" {}
		_WaterColor("Water Color", Color) = (1,1,1,0)
		[HideInInspector]_Normal1("Normal1", 2D) = "white" {}
		[HideInInspector]_Normal2("Normal2", 2D) = "white" {}
		[HideInInspector]_Normal3("Normal3", 2D) = "white" {}
		[HideInInspector]_Smoothness3("Smoothness3", Range( 0 , 1)) = 1
		[HideInInspector]_Smoothness1("Smoothness1", Range( 0 , 1)) = 1
		[HideInInspector]_Smoothness0("Smoothness0", Range( 0 , 1)) = 1
		[HideInInspector]_Smoothness2("Smoothness2", Range( 0 , 1)) = 1
		_WaterSmoothness("Water Smoothness", Float) = 1
		_DisplIntensity("Displ Intensity", Range( 0 , 1)) = 0
		_Displacement("Displacement", 2D) = "white" {}
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
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry-100" "SplatCount"="4" }
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
		uniform float _Metallic;
		uniform float _Smoothness;
		uniform float _WaterSmoothness;
		uniform sampler2D _Displacement;
		uniform float4 _Displacement_ST;
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
			float2 uv_Displacement = v.texcoord * _Displacement_ST.xy + _Displacement_ST.zw;
			float4 tex2DNode18 = tex2Dlod( _Displacement, float4( uv_Displacement, 0, 0.0) );
			float temp_output_22_0 = ( tex2DNode18.r * _DisplIntensity );
			float3 temp_cast_0 = (temp_output_22_0).xxx;
			v.vertex.xyz += temp_cast_0;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Control = i.uv_texcoord * _Control_ST.xy + _Control_ST.zw;
			float4 tex2DNode5_g1 = tex2D( _Control, uv_Control );
			float dotResult20_g1 = dot( tex2DNode5_g1 , float4(1,1,1,1) );
			float SplatWeight22_g1 = dotResult20_g1;
			float4 SplatControl26_g1 = ( tex2DNode5_g1 / ( SplatWeight22_g1 + 0.001 ) );
			float4 temp_output_59_0_g1 = SplatControl26_g1;
			float2 uv_Splat0 = i.uv_texcoord * _Splat0_ST.xy + _Splat0_ST.zw;
			float2 uv_Splat1 = i.uv_texcoord * _Splat1_ST.xy + _Splat1_ST.zw;
			float2 uv_Splat2 = i.uv_texcoord * _Splat2_ST.xy + _Splat2_ST.zw;
			float2 uv_Splat3 = i.uv_texcoord * _Splat3_ST.xy + _Splat3_ST.zw;
			float4 weightedBlendVar8_g1 = temp_output_59_0_g1;
			float4 weightedBlend8_g1 = ( weightedBlendVar8_g1.x*tex2D( _Normal0, uv_Splat0 ) + weightedBlendVar8_g1.y*tex2D( _Normal1, uv_Splat1 ) + weightedBlendVar8_g1.z*tex2D( _Normal2, uv_Splat2 ) + weightedBlendVar8_g1.w*tex2D( _Normal3, uv_Splat3 ) );
			o.Normal = UnpackNormal( weightedBlend8_g1 );
			float4 appendResult33_g1 = (float4(1.0 , 1.0 , 1.0 , _Smoothness0));
			float4 appendResult36_g1 = (float4(1.0 , 1.0 , 1.0 , _Smoothness1));
			float4 appendResult39_g1 = (float4(1.0 , 1.0 , 1.0 , _Smoothness2));
			float4 appendResult42_g1 = (float4(1.0 , 1.0 , 1.0 , _Smoothness3));
			float4 weightedBlendVar9_g1 = temp_output_59_0_g1;
			float4 weightedBlend9_g1 = ( weightedBlendVar9_g1.x*( appendResult33_g1 * tex2D( _Splat0, uv_Splat0 ) ) + weightedBlendVar9_g1.y*( appendResult36_g1 * tex2D( _Splat1, uv_Splat1 ) ) + weightedBlendVar9_g1.z*( appendResult39_g1 * tex2D( _Splat2, uv_Splat2 ) ) + weightedBlendVar9_g1.w*( appendResult42_g1 * tex2D( _Splat3, uv_Splat3 ) ) );
			float4 MixDiffuse28_g1 = weightedBlend9_g1;
			float3 ase_worldPos = i.worldPos;
			float clampResult15 = clamp( ( ( ase_worldPos.y * _SnowStrength ) + _SnowOffset ) , 0.0 , 1.0 );
			float4 lerpResult7 = lerp( MixDiffuse28_g1 , _SnowColor , clampResult15);
			float clampResult50 = clamp( -( ( ase_worldPos.y * _WetnessStrength ) + _WetnessOffset ) , 0.0 , 1.0 );
			float4 lerpResult33 = lerp( lerpResult7 , ( lerpResult7 * _WaterColor ) , clampResult50);
			o.Albedo = lerpResult33.rgb;
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
0;534;1599;484;1948.995;125.8332;1.531007;True;False
Node;AmplifyShaderEditor.WorldPosInputsNode;14;-1646.523,-428.6911;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;16;-1660.993,-257.9533;Float;False;Property;_SnowStrength;Snow Strength;30;0;Create;True;5;0;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;30;-310.0493,-729.8104;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;29;-178.9194,-549.9725;Float;False;Property;_WetnessStrength;Wetness Strength;29;0;Create;True;5;0;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-1354.243,-341.8753;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-1307.941,-88.2495;Float;False;Property;_SnowOffset;Snow Offset;28;0;Create;True;0;0;-10;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;27;57.72475,-441.2442;Float;False;Property;_WetnessOffset;Wetness Offset;27;0;Create;True;0.4090774;0;-10;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;127.8305,-633.8946;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;11;-960.6777,-169.2776;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;15;-690.863,-164.7651;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;1;-1338.825,4.810962;Float;False;Four Splats First Pass Terrain;5;;1;37452fdfb732e1443b7e39720d05b708;0;6;59;FLOAT4;0,0,0,0;False;60;FLOAT4;0,0,0,0;False;61;FLOAT3;0,0,0;False;57;FLOAT;0.0;False;58;FLOAT;0.0;False;62;FLOAT;0.0;False;6;FLOAT4;0;FLOAT3;14;FLOAT;56;FLOAT;45;FLOAT;19;FLOAT;17
Node;AmplifyShaderEditor.ColorNode;13;-609.0732,-347.6632;Float;False;Property;_SnowColor;Snow Color;31;0;Create;True;0.8014706,0.8932049,1,0;0.8014706,0.8932049,1,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;28;365.1856,-567.405;Float;True;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;38;647.7449,-577.6962;Float;True;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;7;-253.697,-87.71158;Float;False;3;0;COLOR;0.0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0.0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;52;-290.1051,-373.8963;Float;False;Property;_WaterColor;Water Color;12;0;Create;True;1,1,1,0;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;21;-429.9564,582.0402;Float;False;Property;_DisplIntensity;Displ Intensity;25;0;Create;True;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;18;-759.2399,457.2048;Float;True;Property;_Displacement;Displacement;26;0;Create;True;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;50;727.1171,-265.8078;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-537.7977,196.146;Float;False;Property;_Smoothness;Smoothness;32;0;Create;True;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;34;190.9159,267.3154;Float;False;Property;_WaterSmoothness;Water Smoothness;23;0;Create;True;1;0;1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;75.96588,-273.7086;Float;False;2;2;0;COLOR;0.0,0,0,0;False;1;COLOR;0.0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;33;880.4272,-106.4192;Float;False;3;0;COLOR;0.0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0.0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;20;-261.7926,265.5;Float;False;2;2;0;FLOAT;0.0;False;1;COLOR;0.0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;2;-536.4975,122.046;Float;False;Property;_Metallic;Metallic;33;0;Create;True;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-172.0537,433.2504;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;26;617.0953,197.2251;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0;False;2;FLOAT;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;24;-28.224,319.1783;Float;False;FLOAT3;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1195.181,16.78631;Float;False;True;6;Float;ASEMaterialInspector;0;0;Standard;Forceling/TerrainFirstPass;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;False;0;Opaque;0.5;True;True;-100;False;Opaque;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;True;0;15;2;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;0;0;1;SplatCount=4;0;False;1;BaseMapShader=ASESampleShaders/SimpleTerrainBase;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;17;0;14;2
WireConnection;17;1;16;0
WireConnection;31;0;30;2
WireConnection;31;1;29;0
WireConnection;11;0;17;0
WireConnection;11;1;9;0
WireConnection;15;0;11;0
WireConnection;28;0;31;0
WireConnection;28;1;27;0
WireConnection;38;0;28;0
WireConnection;7;0;1;0
WireConnection;7;1;13;0
WireConnection;7;2;15;0
WireConnection;50;0;38;0
WireConnection;51;0;7;0
WireConnection;51;1;52;0
WireConnection;33;0;7;0
WireConnection;33;1;51;0
WireConnection;33;2;50;0
WireConnection;20;0;1;17
WireConnection;20;1;18;0
WireConnection;22;0;18;1
WireConnection;22;1;21;0
WireConnection;26;0;3;0
WireConnection;26;1;34;0
WireConnection;26;2;50;0
WireConnection;24;1;22;0
WireConnection;0;0;33;0
WireConnection;0;1;1;14
WireConnection;0;3;2;0
WireConnection;0;4;26;0
WireConnection;0;11;22;0
ASEEND*/
//CHKSM=E7302A6873B3514925698B049716C657B4A53DD6