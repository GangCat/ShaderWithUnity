Shader "KCH/05_NormalMap"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "magenta" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0

        // 노멀맵을 가져오려면 무조건 이름이 _BumpMap이다
        // 아래가 그냥 기본 범퍼맵 형식
		_BumpMap ("NormalMap", 2D) = "bump" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        // LOD가 200이라는 말은 200을 넘어서 멀어지면 쉐이더가 꺼진다
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        // 모델버전을 3.0까지 지원하겠다 지원이 안되는 경우 fallback으로 이동
        #pragma target 3.0

        sampler2D _MainTex;
		sampler2D _BumpMap;

        // 메인텍스랑 범프맵이랑 동일한 녀석이면 굳이 이거 만들 필요가 없음
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
        }
        ENDCG
    }
    FallBack "Diffuse"
}
