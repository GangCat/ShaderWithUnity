Shader "KCH/09_NPRShadow"
{
// 카툰렌더링
// 망가 디멘션 -> 카툰 렌더링 -> 툰 쉐이딩 -> 셀 쉐이딩
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
		
		CGPROGRAM
		#pragma surface surf Toon noambient

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

		float4 LightingToon(SurfaceOutput s, float3 lightDir, float atten)
		{
            // 하프 램버트
			float ndotl = dot(s.Normal, lightDir) * 0.5 + 0.5;

            // 옛날방식
			//if(ndotl > 0.5) ndotl = 1;
			//else ndotl = 0.3;

            // ceil: 올림
            // round: 반올림
            // floor: 내림
			ndotl = ndotl * 5;
			ndotl = ceil(ndotl) / 5;
            // 5칸을 나누고 정수로 몰아준 다음에 다시 5로 나눠서 정규화
            // 얘는 곱셈, 나눗셈이 들어가서 속도가 더 느림
            // 항상 동일한 범위이고 범위를 조절하기 쉽지않음
            // 그래서 위에 방식을 좀 더 선호하는 편

			return ndotl;
		}
        ENDCG
    }
    FallBack "Diffuse"
}
