Shader "KCH/13_AlphaCutout"
{
    // 일정 값 이하면 그냥 잘라버림.
    // 투명화 쉐이더 방법 중 가장 빠름
    // 아예 잘라버리는 거라서 그림자도 모양에 맞춰서 그림자가 나옴
    Properties {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5
    }
    SubShader {
        Tags { "RenderType"="TransparentCutout" "Queue"="AlphaTest" }

        CGPROGRAM
        // 알파: 페이드
        // 알파테스트: 컷오프 -> 알파테스트를 하는 값을 설정, 0이면 안한다는 뜻
        // 알파테스트: 컷오프 이게 더 싸다
        //#pragma surface surf Lambert alpha:fade
        #pragma surface surf Lambert alphatest:_Cutoff

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Transparent/Cutout/Diffuse"
}
