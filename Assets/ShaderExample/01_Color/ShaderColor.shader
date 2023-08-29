// https://docs.unity3d.com/Manual/SL-SurfaceShaders.html

Shader "KCH/01_Color"
{
	Properties
	{
		_colorR ("Color R", Range(0, 1)) = 1
		_colorG ("Color G", Range(0, 1)) = 1
		_colorB ("Color B", Range(0, 1)) = 1

		_Metallic ("Metallic", Range(0, 1)) = 1
		_Glossiness ("Glossiness", Range(0, 1)) = 1
	}

	SubShader
	{
		CGPROGRAM

		// #pragma surface surfaceFunction lightModel [optionalparams]
		#pragma surface surf Standard

		struct Input
		{
			float4 color : COLOR;
		};

		fixed _colorR;
		fixed _colorG;
		fixed _colorB;

		half _Metallic;
		half _Glossiness;

		//struct SurfaceOutputStandard
		//{
		//	fixed3 Albedo;      // 반사되는 색
		//	fixed3 Normal;      // 법선
		//	half3 Emission;		// 발산되는 색
		//	half Metallic;      // 0=메탈 영향 없음, 1=메탈
		//	half Smoothness;    // 0=거칠게, 1=부드럽게
		//	half Occlusion;     // 차폐로 인한 환경광의 영향도 (기본 1)
		//	fixed Alpha;        // 투명도
		//};
		void surf(Input In, inout SurfaceOutputStandard o)
		{
			o.Albedo = float3(_colorR, _colorG, _colorB);
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
		}

		ENDCG
	}
}