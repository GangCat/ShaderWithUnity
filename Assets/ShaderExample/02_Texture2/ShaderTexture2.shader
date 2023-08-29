Shader "KCH/02_ShaderTexture2"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "black" {}
        _MainTexTo ("Albedo (RGB)", 2D) = "black" {}
    }
    SubShader
    {
        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows

        sampler2D _MainTex;
        sampler2D _MainTexTo;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
			fixed4 texColor = tex2D (_MainTex, IN.uv_MainTex);
			fixed4 texToColor = tex2D (_MainTexTo, IN.uv_MainTex);
			o.Emission = lerp(texColor.rgb, texToColor.rgb, 1 - texColor.a);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
