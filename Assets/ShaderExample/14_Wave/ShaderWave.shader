Shader "KCH/14_Wave"
{
    Properties
    {
		// 강도를 나타낼 텍스쳐를 가져옴
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_RefStrength ("Reflection Strengrh", Range(0, 0.1)) = 0.05
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
		zwrite off

		// 유니티만 혼자 이렇게 부름
		// 다른데서는 Rander Texture라고 부름
		// 그 미니맵 만드는 방법 설명할 때 그거
		// 카메라가 찍은 그 화면이 데이터에 올라갈 때 그 그림을 가져오는게 이거임
		GrabPass{}
		
		CGPROGRAM
		#pragma surface surf Nolight noambient alpha:fade

		// 이 이름을 쓰면 그 그림을 가져옴, 고정
		sampler2D _GrabTexture;
		sampler2D _MainTex;
		float _RefStrength;

		struct Input
        {
			// 인풋으로 들어오는 건 우리가 파이프라인으로 들어오는 것을 중간에 인터셉트하는것임
			// 가공하기 전에 가져오는 색은 버텍스 컬러밖에 없다.
			float4 color:COLOR;
			float4 screenPos;
			float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
			float4 ref = tex2D(_MainTex, IN.uv_MainTex);
			
			// 아래 2개 코드는 동일함
			//float3 screenUV = IN.screenPos.rgb / IN.screenPos.a;
			float3 screenUV = IN.screenPos.xyz / IN.screenPos.w;

			//o.Emission = float3(screenUV.xy, 0);
			//o.Emission = tex2D(_GrabTexture, screenUV.xy);
			o.Emission = tex2D(_GrabTexture, (screenUV.xy + ref.x * _RefStrength));
			// ref.x는 그 링 그림의 해당 픽셀의 색상의 크기다. 흑백이니까 ref.x == ref.r 이고 이는 즉 흰색의 정도이다.
        }

		float4 LightingNolight(SurfaceOutput s, float3 lightDir, float atten) {
			return float4(0,0,0,1);
		}
        ENDCG
    }
    FallBack "Legacy Shaders/Transparent/Vertexlit"
}
