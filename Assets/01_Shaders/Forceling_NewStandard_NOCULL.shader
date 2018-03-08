// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Forceling/New Standard_NOCULL"
{
	Properties
	{
		[Header(Translucency)]
		_Translucency("Strength", Range( 0 , 50)) = 1
		_TransNormalDistortion("Normal Distortion", Range( 0 , 1)) = 0.1
		_TransScattering("Scaterring Falloff", Range( 1 , 50)) = 2
		_TransDirect("Direct", Range( 0 , 1)) = 1
		_TransAmbient("Ambient", Range( 0 , 1)) = 0.2
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_TransShadow("Shadow", Range( 0 , 1)) = 0.9
		_Albedo("Albedo", 2D) = "white" {}
		_AlbedoTint("Albedo Tint", Color) = (1,1,1,0)
		_MAOHS("M/AO/H/S", 2D) = "white" {}
		_MetallicIntensity("Metallic Intensity", Range( 0 , 1)) = 0
		_OcclusionIntensity("Occlusion Intensity", Range( 0 , 1)) = 1
		_SmoothnessIntensity("Smoothness Intensity", Range( 0 , 1)) = 0
		_Normal("Normal", 2D) = "bump" {}
		[Header(Forceling_Normal_Intensity)]
		_NormalIntensity("Normal Intensity", Range( 0 , 10)) = 1
		[Toggle]_UseEmissive("Use Emissive", Float) = 0
		_Emissive("Emissive", 2D) = "black" {}
		[HDR]_EmissiveIntensity("Emissive Intensity", Float) = 1
		[HDR]_EmissiveTint("Emissive Tint", Color) = (1,1,1,0)
		_Float3("Float 3", Float) = 0.1
		_Float1("Float 1", Float) = 1
		_Float2("Float 2", Float) = 0.5
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 5.0
		#pragma multi_compile_instancing
		#pragma surface surf StandardCustom keepalpha addshadow fullforwardshadows exclude_path:deferred vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
		};

		struct SurfaceOutputStandardCustom
		{
			fixed3 Albedo;
			fixed3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			fixed Alpha;
			fixed3 Translucency;
		};

		uniform sampler2D _Normal;
		uniform float4 _Normal_ST;
		uniform float _NormalIntensity;
		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;
		uniform float4 _AlbedoTint;
		uniform float _UseEmissive;
		uniform sampler2D _Emissive;
		uniform float4 _Emissive_ST;
		uniform float4 _EmissiveTint;
		uniform float _EmissiveIntensity;
		uniform sampler2D _MAOHS;
		uniform float4 _MAOHS_ST;
		uniform float _MetallicIntensity;
		uniform float _SmoothnessIntensity;
		uniform float _OcclusionIntensity;
		uniform half _Translucency;
		uniform half _TransNormalDistortion;
		uniform half _TransScattering;
		uniform half _TransDirect;
		uniform half _TransAmbient;
		uniform half _TransShadow;
		uniform float _Float1;
		uniform float _Float2;
		uniform float _Float3;
		uniform float _Cutoff = 0.5;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float mulTime63 = _Time.y * _Float2;
			float clampResult71 = clamp( (0 + (sin( ( _Float1 * ( ase_vertex3Pos.y + mulTime63 ) * 6.28318548202515 ) ) - -1) * (1 - 0) / (1 - -1)) , 0 , 1 );
			float3 ase_vertexNormal = v.normal.xyz;
			v.vertex.xyz += ( clampResult71 * ase_vertexNormal * _Float3 );
		}

		inline half4 LightingStandardCustom(SurfaceOutputStandardCustom s, half3 viewDir, UnityGI gi )
		{
			#if !DIRECTIONAL
			float3 lightAtten = gi.light.color;
			#else
			float3 lightAtten = lerp( _LightColor0.rgb, gi.light.color, _TransShadow );
			#endif
			half3 lightDir = gi.light.dir + s.Normal * _TransNormalDistortion;
			half transVdotL = pow( saturate( dot( viewDir, -lightDir ) ), _TransScattering );
			half3 translucency = lightAtten * (transVdotL * _TransDirect + gi.indirect.diffuse * _TransAmbient) * s.Translucency;
			half4 c = half4( s.Albedo * translucency * _Translucency, 0 );

			SurfaceOutputStandard r;
			r.Albedo = s.Albedo;
			r.Normal = s.Normal;
			r.Emission = s.Emission;
			r.Metallic = s.Metallic;
			r.Smoothness = s.Smoothness;
			r.Occlusion = s.Occlusion;
			r.Alpha = s.Alpha;
			return LightingStandard (r, viewDir, gi) + c;
		}

		inline void LightingStandardCustom_GI(SurfaceOutputStandardCustom s, UnityGIInput data, inout UnityGI gi )
		{
			#if defined(UNITY_PASS_DEFERRED) && UNITY_ENABLE_REFLECTION_BUFFERS
				gi = UnityGlobalIllumination(data, s.Occlusion, s.Normal);
			#else
				UNITY_GLOSSY_ENV_FROM_SURFACE( g, s, data );
				gi = UnityGlobalIllumination( data, s.Occlusion, s.Normal, g );
			#endif
		}

		void surf( Input i , inout SurfaceOutputStandardCustom o )
		{
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			float4 appendResult5_g1 = (float4(( (UnpackNormal( tex2D( _Normal, uv_Normal ) )).xy * _NormalIntensity ) , 1.0 , 0));
			o.Normal = appendResult5_g1.xyz;
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			float4 tex2DNode1 = tex2D( _Albedo, uv_Albedo );
			float4 temp_output_58_0 = ( tex2DNode1 * _AlbedoTint );
			o.Albedo = temp_output_58_0.rgb;
			float4 temp_cast_2 = (0.0).xxxx;
			float2 uv_Emissive = i.uv_texcoord * _Emissive_ST.xy + _Emissive_ST.zw;
			o.Emission = lerp(temp_cast_2,( tex2D( _Emissive, uv_Emissive ) * ( _EmissiveTint * exp( _EmissiveIntensity ) ) ),_UseEmissive).rgb;
			float2 uv_MAOHS = i.uv_texcoord * _MAOHS_ST.xy + _MAOHS_ST.zw;
			float4 tex2DNode3 = tex2D( _MAOHS, uv_MAOHS );
			o.Metallic = ( tex2DNode3.r * _MetallicIntensity );
			o.Smoothness = ( tex2DNode3.a * _SmoothnessIntensity );
			o.Occlusion = pow( tex2DNode3.g , _OcclusionIntensity );
			o.Translucency = temp_output_58_0.rgb;
			o.Alpha = 1;
			clip( tex2DNode1.a - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=14501
-1913;29;1906;1004;3002.94;-1918.118;1;True;False
Node;AmplifyShaderEditor.PosVertexDataNode;62;-2039.051,2114.921;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;61;-1517.673,2526.835;Float;False;Property;_Float2;Float 2;23;0;Create;True;0;0.5;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;63;-1237.119,2496.888;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;64;-1297.497,2221.892;Float;True;True;False;False;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;60;-889.8405,2195.108;Float;False;Property;_Float1;Float 1;22;0;Create;True;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TauNode;65;-789.566,2545.06;Float;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;66;-891.9457,2369.222;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;54;-555.0022,1734.977;Float;False;Property;_EmissiveIntensity;Emissive Intensity;19;1;[HDR];Create;True;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;67;-611.2543,2346.935;Float;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;20;-533.4676,1474.833;Float;False;Property;_EmissiveTint;Emissive Tint;20;1;[HDR];Create;True;0;1,1,1,0;1,1,1,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ExpOpNode;55;-254.1988,1612.281;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;68;-273.2898,2355.567;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;69;16.53955,2362.081;Float;True;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;21;-557.4127,1250.631;Float;True;Property;_Emissive;Emissive;18;0;Create;True;0;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;-87.70387,1486.149;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1;-927.6048,-326.8414;Float;True;Property;_Albedo;Albedo;7;0;Create;True;0;None;f59ca8259629e294f84f84e971a4d607;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;56;233.2877,1042.55;Float;False;Constant;_Float0;Float 0;12;0;Create;True;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-940,68;Float;True;Property;_Normal;Normal;14;0;Create;True;0;None;6d4705cbdc4fe4a4081508cc30e8ca1a;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;226.8977,1258.811;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;57;-845.975,-125.4661;Float;False;Property;_AlbedoTint;Albedo Tint;8;0;Create;True;0;1,1,1,0;1,1,1,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;3;-946,282;Float;True;Property;_MAOHS;M/AO/H/S;9;0;Create;True;0;None;660c5187cea96414bbef17a825e04d0d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalVertexDataNode;72;226.7076,2664.024;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;71;374.0067,2412.552;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;70;390.6876,2886.188;Float;False;Property;_Float3;Float 3;21;0;Create;True;0;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-735,501;Float;False;Property;_MetallicIntensity;Metallic Intensity;10;0;Create;True;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-746,1003;Float;False;Property;_OcclusionIntensity;Occlusion Intensity;11;0;Create;True;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-733,641;Float;False;Property;_SmoothnessIntensity;Smoothness Intensity;13;0;Create;True;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;12;-390,935;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-332,383;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;59;-545.4821,192.527;Float;False;Forceling_Normal_Intensity;15;;1;20d7127783ec9294d8bfec335ba05b4d;0;1;6;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;-169.6477,-265.3373;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-735,746;Float;False;Property;_HeightIntensity;Height Intensity;12;0;Create;True;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;73;681.1464,2631.388;Float;True;3;3;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldPosInputsNode;74;-1604.383,2329.189;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TextureCoordinatesNode;75;-1616.167,2201.442;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-314,702;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;52;499.7716,1043.853;Float;False;Property;_UseEmissive;Use Emissive;17;0;Create;True;0;0;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-327,531;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1458.669,88.78799;Float;False;True;7;Float;ASEMaterialInspector;0;0;Standard;Forceling/New Standard_NOCULL;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;Off;0;0;False;0;0;False;0;Custom;0.5;True;True;0;True;TransparentCutout;;Geometry;ForwardOnly;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;0;15;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;6;0;-1;-1;0;0;0;False;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;63;0;61;0
WireConnection;64;0;62;2
WireConnection;66;0;64;0
WireConnection;66;1;63;0
WireConnection;67;0;60;0
WireConnection;67;1;66;0
WireConnection;67;2;65;0
WireConnection;55;0;54;0
WireConnection;68;0;67;0
WireConnection;69;0;68;0
WireConnection;53;0;20;0
WireConnection;53;1;55;0
WireConnection;25;0;21;0
WireConnection;25;1;53;0
WireConnection;71;0;69;0
WireConnection;12;0;3;2
WireConnection;12;1;14;0
WireConnection;9;0;3;1
WireConnection;9;1;4;0
WireConnection;59;6;2;0
WireConnection;58;0;1;0
WireConnection;58;1;57;0
WireConnection;73;0;71;0
WireConnection;73;1;72;0
WireConnection;73;2;70;0
WireConnection;11;0;3;3
WireConnection;11;1;7;0
WireConnection;52;0;56;0
WireConnection;52;1;25;0
WireConnection;10;0;3;4
WireConnection;10;1;6;0
WireConnection;0;0;58;0
WireConnection;0;1;59;0
WireConnection;0;2;52;0
WireConnection;0;3;9;0
WireConnection;0;4;10;0
WireConnection;0;5;12;0
WireConnection;0;7;58;0
WireConnection;0;10;1;4
WireConnection;0;11;73;0
ASEEND*/
//CHKSM=05718A95B6765D52C1DE792024E64C0B15C39482