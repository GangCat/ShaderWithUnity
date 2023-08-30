Shader "KCH/15_Dissolve"
{
    Properties
    {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_NoiseTex ("NoiseTex", 2D) = "white" {}
		_Cut ("Alpha Cut", Range(0, 1)) = 0
		// 색상 앞에 HDR이라고 하면 HDR 컬러를 사용할 수 있다.
		// High Dynamic Range 밝기도 조절할 수 있는거
		[HDR]_OutColor ("OutColor", Color) = (1, 1, 1, 1)
		// 약간 인스크립션 카드 죽을 때 타면서 죽는것처럼 하는 거
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
			
			// _Cut보다 크면 그리고 아니면 안그림 마치 cutoff
			float alpha;
			if (noise.r >= _Cut) alpha = 1;
			else alpha = 0;

			// _Cut보다 조금 더 크게 해서 비교하고 크면 라인을 안그리고 작으면 라인을 그림
			float outline;
			if (noise.r >= _Cut * 1.5) outline = 0;
			else outline = 1;

			// 그러고나서 emission을 추가해줌
			o.Emission = outline * _OutColor.rgb;

			o.Alpha = alpha;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
