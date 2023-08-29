Shader "KCH/07_Fresnel"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_BumpMap ("NormalMap", 2D) = "bump" {}
		_RimColor ("RimColor", Color) = (1, 1, 1, 1)
		_RimPower ("RimPower", Range(1, 10)) = 3
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf Test

        sampler2D _MainTex;
		sampler2D _BumpMap;
		float4 _RimColor;
		float _RimPower;
        float rim;

        struct Input
        {
            float2 uv_MainTex;
			float2 uv_BumpMap;
			float3 viewDir;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
            o.Albedo = c.rgb;
            o.Alpha = c.a;
            rim = saturate(dot(o.Normal, IN.viewDir));
        }

        float4 LightingTest(SurfaceOutput s, float3 lightDir, float atten)
        {
            float ndotl = saturate(dot(s.Normal, lightDir));

            float4 final;

            final.a = s.Alpha;
            // 라이트랑 노말이랑 이루는 내적의 크기가 0.5보다 클 때
            final.rgb = s.Albedo * ndotl * _LightColor0.rgb * atten;

            if(rim < 0.2)
            {
                if(ndotl > 0.7)
                    final.rgb += pow(1-rim, _RimPower) * _LightColor0.rgb;
            }

            return final;
        }

        ENDCG
    }
    FallBack "Diffuse"
}
