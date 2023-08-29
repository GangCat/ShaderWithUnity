Shader "KCH/06_HalfLambert"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_BumpMap ("NormalMap", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Test 

        sampler2D _MainTex;
		sampler2D _BumpMap;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
        }

		float4 LightingTest (SurfaceOutput s,
		                     float3 lightDir,
							 float atten) {
			//return float4(1, 0, 0, 1);

			//float ndotl = dot(s.Normal, lightDir);
			//float ndotl = saturate(dot(s.Normal, lightDir));
            // saturate 대신에 *0.5 +0.5하면 명암도 심하지 않고 적당히 밝아서 좋았다.
            // 이걸 찾아낸게 밸브의 하프라이프임
			float ndotl = dot(s.Normal, lightDir) * 0.5 + 0.5;
			return ndotl;
		}

        ENDCG

		//struct SurfaceOutput
		//{
		//	half3 Albedo;		// 기본 색상
		//	half3 Normal;		// Normal Map
		//	half3 Emission;		// 빛의 영향을 받지않는 색상
		//	half Specular;		// 반사광
		//	half Gloss;			// Specular의 강도
		//	half Alpha;			// 알파
		//};
    }
    FallBack "Diffuse"
}
