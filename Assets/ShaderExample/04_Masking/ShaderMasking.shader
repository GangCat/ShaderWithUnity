Shader "KCH/04_Masking"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _MainTex2 ("Albedo (RGB)", 2D) = "white" {}
        _MainTex3 ("Albedo (RGB)", 2D) = "white" {}
        _MainTex4 ("Albedo (RGB)", 2D) = "white" {}
        _MainTex5 ("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        // 기본적으로 
        //Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf Standard

        sampler2D _MainTex;
        sampler2D _MainTex2;
        sampler2D _MainTex3;
        sampler2D _MainTex4;
        sampler2D _MainTex5;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            //fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            //fixed4 c2 = tex2D (_MainTex2, IN.uv_MainTex);
            //o.Emission = c.rgb * c2.rgb;

			fixed4 maskC = tex2D (_MainTex, IN.uv_MainTex);
			fixed4 baseC = tex2D (_MainTex2, IN.uv_MainTex);
			fixed4 c3 = tex2D (_MainTex3, IN.uv_MainTex);
			fixed4 c4 = tex2D (_MainTex4, IN.uv_MainTex);
			fixed4 c5 = tex2D (_MainTex5, IN.uv_MainTex);

            // 선형보간으로 만들면 비용이 비싸다.
            
			//o.Albedo = lerp(baseC.rgb, c3.rgb, maskC.r);
			//o.Albedo = lerp(o.Albedo, c4.rgb, maskC.g);
			//o.Albedo = lerp(o.Albedo, c5.rgb, maskC.b);

			o.Albedo = c3.rgb * maskC.r +
					   c4.rgb * maskC.g +
					   c5.rgb * maskC.b +
			           baseC * (1 - (maskC.r + maskC.g + maskC.b));
        }
        ENDCG
    }
    FallBack "Diffuse"
}
