// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Forceling/DepthFade"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_DistanceContrast("Distance Contrast", Range( 0 , 5)) = 0
		_Distance("Distance", Range( 0 , 5)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Back
		GrabPass{ }
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#include "UnityCG.cginc"
		#pragma target 3.0
		#pragma multi_compile_instancing
		#pragma surface surf StandardCustomLighting keepalpha addshadow fullforwardshadows noforwardadd dithercrossfade 
		struct Input
		{
			float4 screenPos;
			float2 uv_texcoord;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			fixed3 Albedo;
			fixed3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			fixed Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform sampler2D _GrabTexture;
		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;
		uniform sampler2D _CameraDepthTexture;
		uniform float _Distance;
		uniform float _DistanceContrast;


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


		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			c.rgb = 0;
			c.a = 1;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			o.Normal = float3(0,0,1);
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 screenColor121 = tex2Dproj( _GrabTexture, UNITY_PROJ_COORD( ase_grabScreenPos ) );
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth114 = LinearEyeDepth(UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture,UNITY_PROJ_COORD(ase_screenPos))));
			float distanceDepth114 = abs( ( screenDepth114 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _Distance ) );
			float clampResult113 = clamp( ( distanceDepth114 * _DistanceContrast ) , 0.0 , 1.0 );
			float4 lerpResult117 = lerp( screenColor121 , tex2D( _TextureSample0, uv_TextureSample0 ) , clampResult113);
			o.Emission = lerpResult117.rgb;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=14401
0;456;1405;562;-181.779;-117.3766;1.505595;True;False
Node;AmplifyShaderEditor.RangedFloatNode;128;-71.64832,269.6498;Float;False;Property;_Distance;Distance;15;0;Create;True;0;0.06;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;132;70.47955,589.929;Float;False;Property;_DistanceContrast;Distance Contrast;14;0;Create;True;0;1.68;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;114;229.5038,311.1482;Float;False;True;1;0;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;131;420.4796,405.929;Float;True;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenColorNode;121;571.1597,-188.7253;Float;False;Global;_GrabScreen1;Grab Screen 1;13;0;Create;True;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;122;474.1751,-8.162066;Float;True;Property;_TextureSample0;Texture Sample 0;13;0;Create;True;None;b297077dae62c1944ba14cad801cddf5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;113;543.5038,238.1482;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;60;-70.17702,-1107.747;Float;False;985.6011;418.6005;Get screen color for refraction and disturbe it with normals;6;67;66;65;64;63;62;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-736.2825,758.8248;Float;False;Property;_HeightIntensity;Height Intensity;5;0;Create;True;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-927.6048,-326.8414;Float;True;Property;_Albedo;Albedo;0;0;Create;True;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;54;-555.0022,1734.977;Float;False;Property;_EmissiveIntensity;Emissive Intensity;10;1;[HDR];Create;True;0;1;1;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;56;233.2877,1042.55;Float;False;Constant;_Float0;Float 0;12;0;Create;True;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;52;499.7716,1043.853;Float;False;Property;_UseEmissive;Use Emissive;8;0;Create;True;0;2;0;COLOR;0,0,0,0;False;1;COLOR;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;70;876.9508,-611.7147;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GrabScreenPosition;63;-26.07013,-1048.389;Float;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;117;995.2169,151.4983;Float;False;3;0;COLOR;0.0;False;1;COLOR;0.0,0,0,0;False;2;FLOAT;0.0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;-87.70387,1486.149;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;20;-533.4676,1474.833;Float;False;Property;_EmissiveTint;Emissive Tint;11;1;[HDR];Create;True;1,1,1,1;1,1,1,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;62;-35.61171,-785.5057;Float;False;Constant;_Distortion;Distortion;8;0;Create;True;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-332,383;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;66;503.9231,-952.6467;Float;False;2;2;0;FLOAT2;0,0;False;1;COLOR;0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;12;-390,935;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;21;-557.4127,1250.631;Float;True;Property;_Emissive;Emissive;9;0;Create;True;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;3;-946,282;Float;True;Property;_MAOHS;M/AO/H/S;2;0;Create;True;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;14;-746,1003;Float;False;Property;_OcclusionIntensity;Occlusion Intensity;4;0;Create;True;0;1;1;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenColorNode;67;695.424,-956.4467;Float;False;Global;_GrabScreen0;Grab Screen 0;-1;0;Create;True;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-321.695,718.6722;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;226.8977,1258.811;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;65;277.2776,-991.2547;Float;False;True;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ExpOpNode;55;-254.1988,1612.281;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-733,641;Float;False;Property;_SmoothnessIntensity;Smoothness Intensity;6;0;Create;True;0;1;1;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;69;1116.406,-545.2444;Float;False;Property;_UseDepthFade;Use Depth Fade;12;0;Create;True;0;2;0;COLOR;0,0,0,0;False;1;COLOR;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;175.6684,-201.6292;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-327,531;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-940,68;Float;True;Property;_Normal;Normal;7;0;Create;True;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;57;-845.975,-125.4661;Float;False;Property;_AlbedoTint;Albedo Tint;1;0;Create;True;1,1,1,1;1,1,1,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;4;-735,501;Float;False;Property;_MetallicIntensity;Metallic Intensity;3;0;Create;True;0;1;1;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;350.8247,-885.7465;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1431.463,99.14406;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Forceling/DepthFade;False;False;False;False;False;False;False;False;False;False;False;False;True;False;True;False;True;Back;0;0;False;0;0;False;0;Translucent;0.5;True;True;0;False;Opaque;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;2;15;10;25;False;0.5;True;0;SrcAlpha;OneMinusSrcAlpha;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;114;0;128;0
WireConnection;131;0;114;0
WireConnection;131;1;132;0
WireConnection;113;0;131;0
WireConnection;52;0;56;0
WireConnection;52;1;25;0
WireConnection;70;0;58;0
WireConnection;70;1;67;0
WireConnection;117;0;121;0
WireConnection;117;1;122;0
WireConnection;117;2;113;0
WireConnection;53;0;20;0
WireConnection;53;1;55;0
WireConnection;9;0;3;1
WireConnection;9;1;4;0
WireConnection;66;0;65;0
WireConnection;66;1;64;0
WireConnection;12;0;3;2
WireConnection;12;1;14;0
WireConnection;67;0;66;0
WireConnection;11;0;3;3
WireConnection;11;1;7;0
WireConnection;25;0;21;0
WireConnection;25;1;53;0
WireConnection;65;0;63;0
WireConnection;55;0;54;0
WireConnection;69;0;58;0
WireConnection;69;1;70;0
WireConnection;58;0;1;0
WireConnection;58;1;57;0
WireConnection;10;0;3;4
WireConnection;10;1;6;0
WireConnection;64;0;2;0
WireConnection;64;1;62;0
WireConnection;0;15;117;0
ASEEND*/
//CHKSM=2C8D71AD7E4D4527E227016D42D43F5E0554DA9F