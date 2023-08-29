Shader "KCH/15_Dissolve"
{
    Properties
    {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_NoiseTex ("NoiseTex", 2D) = "white" {}
		_Cut ("Alpha Cut", Range(0, 1)) = 0
		[HDR]_OutColor ("OutColor", Color) = (1, 1, 1, 1)
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }
		
		CGPROGRAM
		#pragma surface surf Lambert alpha:fade

		sampler2D _MainTex;
		sampler2D _NoiseTex;
		float _Cut;
		float4 _OutColor;

		struct Input
        {
			float2 uv_MainTex;
			float2 uv_NoiseTex;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
			float4 c = tex2D(_MainTex, IN.uv_MainTex);
			float4 noise = tex2D(_NoiseTex, IN.uv_NoiseTex);
			o.Albedo = c.rgb;
			
			float alpha;
			if (noise.r >= _Cut) alpha = 1;
			else alpha = 0;

			float outline;
			if (noise.r >= _Cut * 1.5) outline = 0;
			else outline = 1;
			o.Emission = outline * _OutColor.rgb;

			o.Alpha = alpha;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
