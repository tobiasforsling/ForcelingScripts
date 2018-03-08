// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Forceling/New Standard"
{
	Properties
	{
		_Albedo("Albedo", 2D) = "white" {}
		_AlbedoTint("Albedo Tint", Color) = (1,1,1,1)
		_MAOHS("M/AO/H/S", 2D) = "white" {}
		_MetallicIntensity("Metallic Intensity", Range( 1 , 0)) = 0
		_OcclusionIntensity("Occlusion Intensity", Range( 1 , 0)) = 0
		_SmoothnessIntensity("Smoothness Intensity", Range( 1 , 0)) = 0
		_Normal("Normal", 2D) = "white" {}
		[Toggle]_UseEmissive("Use Emissive", Float) = 0
		_Emissive("Emissive", 2D) = "white" {}
		[HDR]_EmissiveIntensity("Emissive Intensity", Range( 1 , 0)) = 0
		[HDR]_EmissiveTint("Emissive Tint", Color) = (1,1,1,1)
		_DepthFade("Depth Fade", Range( 0 , 5)) = 0
		[Toggle]_UseDepthFade("Use Depth Fade", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Transparent+0" "IsEmissive" = "true"  }
		Cull Back
		GrabPass{ }
		CGPROGRAM
		#include "UnityCG.cginc"
		#pragma target 5.0
		#pragma multi_compile_instancing
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows dithercrossfade 
		struct Input
		{
			float2 uv_texcoord;
			float4 screenPos;
		};

		uniform sampler2D _Normal;
		uniform float4 _Normal_ST;
		uniform float _UseDepthFade;
		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;
		uniform float4 _AlbedoTint;
		uniform sampler2D _GrabTexture;
		uniform sampler2D _CameraDepthTexture;
		uniform float _DepthFade;
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


		inline float4 ASE_ComputeGrabScreenPos( float4 pos )
		{
			#if UNITY_UV_STARTS_AT_TOP
			float scale = -1.0;
			#else
			float scale = 1.0;
			#endif
			float4 o = pos;
			o.y = pos.w * 0.5f;
			o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
			return o;
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			o.Normal = tex2D( _Normal, uv_Normal ).rgb;
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			float4 tex2DNode1 = tex2D( _Albedo, uv_Albedo );
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 screenColor77 = tex2Dproj( _GrabTexture, UNITY_PROJ_COORD( ase_grabScreenPos ) );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth73 = LinearEyeDepth(UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture,UNITY_PROJ_COORD(ase_screenPos))));
			float distanceDepth73 = abs( ( screenDepth73 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _DepthFade ) );
			float clampResult74 = clamp( distanceDepth73 , 0.0 , 1.0 );
			float4 lerpResult78 = lerp( tex2DNode1 , screenColor77 , ( 1.0 - clampResult74 ));
			o.Albedo = lerp(( tex2DNode1 * _AlbedoTint ),lerpResult78,_UseDepthFade).rgb;
			float4 temp_cast_2 = (0.0).xxxx;
			float2 uv_Emissive = i.uv_texcoord * _Emissive_ST.xy + _Emissive_ST.zw;
			o.Emission = lerp(temp_cast_2,( tex2D( _Emissive, uv_Emissive ) * ( _EmissiveTint * exp( _EmissiveIntensity ) ) ),_UseEmissive).rgb;
			float2 uv_MAOHS = i.uv_texcoord * _MAOHS_ST.xy + _MAOHS_ST.zw;
			float4 tex2DNode3 = tex2D( _MAOHS, uv_MAOHS );
			o.Metallic = ( tex2DNode3.r * _MetallicIntensity );
			o.Smoothness = ( tex2DNode3.a * _SmoothnessIntensity );
			o.Occlusion = pow( tex2DNode3.g , _OcclusionIntensity );
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=14401
-1913;29;1906;1004;2560.506;1602.593;1.869549;True;False
Node;AmplifyShaderEditor.RangedFloatNode;72;-1716.76,-1074.127;Float;False;Property;_DepthFade;Depth Fade;12;0;Create;True;0;0.19;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;73;-1380.936,-1070.271;Float;False;True;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;54;-555.0022,1734.977;Float;False;Property;_EmissiveIntensity;Emissive Intensity;10;1;[HDR];Create;True;0;0;1;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;74;-1007.386,-1067.11;Float;False;3;0;FLOAT;0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;20;-533.4676,1474.833;Float;False;Property;_EmissiveTint;Emissive Tint;11;1;[HDR];Create;True;1,1,1,1;1,1,1,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ExpOpNode;55;-254.1988,1612.281;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenColorNode;77;-1217.315,-836.0333;Float;False;Global;_GrabScreen1;Grab Screen 1;14;0;Create;True;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;57;-845.975,-125.4661;Float;False;Property;_AlbedoTint;Albedo Tint;1;0;Create;True;1,1,1,1;1,1,1,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-927.6048,-326.8414;Float;True;Property;_Albedo;Albedo;0;0;Create;True;None;64e7766099ad46747a07014e44d0aea1;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;-87.70387,1486.149;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;21;-557.4127,1250.631;Float;True;Property;_Emissive;Emissive;9;0;Create;True;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;75;-733.0874,-1062.602;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;175.6684,-201.6292;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-735,501;Float;False;Property;_MetallicIntensity;Metallic Intensity;3;0;Create;True;0;0;1;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;3;-946,282;Float;True;Property;_MAOHS;M/AO/H/S;2;0;Create;True;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;78;-164.1099,-838.3981;Float;False;3;0;COLOR;0.0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-746,1003;Float;False;Property;_OcclusionIntensity;Occlusion Intensity;4;0;Create;True;0;0;1;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;226.8977,1258.811;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;56;233.2877,1042.55;Float;False;Constant;_Float0;Float 0;12;0;Create;True;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-733,641;Float;False;Property;_SmoothnessIntensity;Smoothness Intensity;6;0;Create;True;0;0;1;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-736.2825,758.8248;Float;False;Property;_HeightIntensity;Height Intensity;5;0;Create;True;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;12;-390,935;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;69;863.537,-316.458;Float;False;Property;_UseDepthFade;Use Depth Fade;13;0;Create;True;1;2;0;COLOR;0,0,0,0;False;1;COLOR;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-321.695,718.6722;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-327,531;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-940,68;Float;True;Property;_Normal;Normal;7;0;Create;True;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ToggleSwitchNode;52;499.7716,1043.853;Float;False;Property;_UseEmissive;Use Emissive;8;0;Create;True;0;2;0;COLOR;0,0,0,0;False;1;COLOR;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-332,383;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1458.669,88.78799;Float;False;True;7;Float;ASEMaterialInspector;0;0;Standard;Forceling/New Standard;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;True;Back;0;0;False;0;0;False;0;Translucent;0.5;True;True;0;False;Opaque;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;2;15;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;73;0;72;0
WireConnection;74;0;73;0
WireConnection;55;0;54;0
WireConnection;53;0;20;0
WireConnection;53;1;55;0
WireConnection;75;0;74;0
WireConnection;58;0;1;0
WireConnection;58;1;57;0
WireConnection;78;0;1;0
WireConnection;78;1;77;0
WireConnection;78;2;75;0
WireConnection;25;0;21;0
WireConnection;25;1;53;0
WireConnection;12;0;3;2
WireConnection;12;1;14;0
WireConnection;69;0;58;0
WireConnection;69;1;78;0
WireConnection;11;0;3;3
WireConnection;11;1;7;0
WireConnection;10;0;3;4
WireConnection;10;1;6;0
WireConnection;52;0;56;0
WireConnection;52;1;25;0
WireConnection;9;0;3;1
WireConnection;9;1;4;0
WireConnection;0;0;69;0
WireConnection;0;1;2;0
WireConnection;0;2;52;0
WireConnection;0;3;9;0
WireConnection;0;4;10;0
WireConnection;0;5;12;0
ASEEND*/
//CHKSM=26EA8FCC668DBA3998B943E61C84FFE88173506E