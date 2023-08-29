Shader "KCH/05_Occulusion"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
		_BumpMap ("NormalMap", 2D) = "bump" {}
		_Occlusion ("Occlusion", 2D) = "whilte" {}
    }
    SubShader
    {
        // 얘는 마스크랑은 좀 다른 느낌
        // 오큘루전: 차폐
        // 오큘루전 매핑: 여기는 조명 계산하고 여기는 적게하세요~ 하는 의미
        // 얘는 조명 계산을 좀 더 자세하게 할 수 있도록 도와주는 것.
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
		sampler2D _BumpMap;
		sampler2D _Occlusion;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
        };

        half _Glossiness;
        half _Metallic;

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
			fixed4 n = tex2D (_BumpMap, IN.uv_BumpMap);
			o.Normal = UnpackNormal(n);
            o.Albedo = c.rgb;
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
            // 오큘루전을 해주는 변수가 있음
            // 그냥 맵 넣고 이거 돌리면 됨
            // 얘는 아에 조명계산을 차단하기 위해서 사용하는게 아니라 명암을 더 멋지게 주기 위한 녀석임.
            // 그래서 아예 조명계산을 못하게 하는 거는 아님.
			o.Occlusion
				= tex2D (_Occlusion, IN.uv_MainTex);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
