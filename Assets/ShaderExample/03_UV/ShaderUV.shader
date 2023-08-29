Shader "KCH/03_ShaderUV"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // uv는 0~1의 실수이다.
            //o.Emission = IN.uv_MainTex.x;
            //o.Emission = IN.uv_MainTex.y;
            //o.Emission = float3(IN.uv_MainTex.x, IN.uv_MainTex.y, 0);
            // 결국 쉐이더에서 나오는건 색이다.
            // 그리고 색은 숫자이다.
            // 그러니 숫자놀음만 잘 하면 색을 표현할 수 있다.

            // 우리는 값을 가지고올 수는 있지만 바꿀 수는 없다.
            // 그래서 그 값에 더하고 나누고 하면서 가지고 노는 것이다.
			fixed4 c = tex2D (_MainTex, fixed2(IN.uv_MainTex.x + 0.5, IN.uv_MainTex.y));
			o.Emission = c.rgb;
        }
        ENDCG
    }
    // 모바일 게임의 경우 기기마다 칩셋의 사양에 따라 쉐이더 코드가 적용이 될 수도 있고 안될 수도 있다.
    // 만일 쉐이더가 적용이 되지 않는 경우에 아래에 해당하는 쉐이더가 적용되도록 하는 키워드이다.
    FallBack "Diffuse"
}
