Shader "KCH/14_Wave"
{
    Properties
    {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_RefStrength ("Reflection Strengrh", Range(0, 0.1)) = 0.05
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
		zwrite off

		GrabPass{}
		
		CGPROGRAM
		#pragma surface surf Nolight noambient alpha:fade

		sampler2D _GrabTexture;
		sampler2D _MainTex;
		float _RefStrength;

		struct Input
        {
			float4 color:COLOR;
			float4 screenPos;
			float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
			float4 ref = tex2D(_MainTex, IN.uv_MainTex);
			float3 screenUV = IN.screenPos.rgb / IN.screenPos.a;
			//o.Emission = float3(screenUV.xy, 0);
			//o.Emission = tex2D(_GrabTexture, screenUV.xy);
			o.Emission = tex2D(_GrabTexture, (screenUV.xy + ref.x * _RefStrength));
        }

		float4 LightingNolight(SurfaceOutput s, float3 lightDir, float atten) {
			return float4(0,0,0,1);
		}
        ENDCG
    }
    FallBack "Legacy Shaders/Transparent/Vertexlit"
}
