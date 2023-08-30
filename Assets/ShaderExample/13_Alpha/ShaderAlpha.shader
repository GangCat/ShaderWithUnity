Shader "KCH/13_Alpha"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "magenta" {}
	}
// 깊이 버퍼를 보여주는 내용
// 깊이 버퍼를 가져와야 아웃라인을 그리거나 뭐 할 수 있다.
// 원래는 포워드로도 보여야하는데 왠지 안보임
    SubShader {
        Tags { "RenderType"="Opaque" }

		CGPROGRAM
		#pragma surface surf Lambert noambient noshadow

		// 깊이 버퍼를 유니티에서 가져오는거라 샘플러명이 고정임
		// 즉 글카에서 가져오는 것
		// 깊이 버퍼가 저장된 텍스쳐를 가져옴
		sampler2D _CameraDepthTexture;
		sampler2D _MainTex;

		struct Input {
			// 스크린의 위치값을 가져옴.
			// 현재 픽셀의 스크립 표지션
			float4 screenPos;
			float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutput o) {
			// 원래 rp에서 호모지니어스 좌표때문에 w로 x, y, z를 나눠준다.-> 원근감을 준다.
			// 스크린 포즈를 기준으로 이 sPos를 가져오는거다.
			float2 sPos = float2(IN.screenPos.x, IN.screenPos.y) / IN.screenPos.w;
			//float4 Depth = tex2D(_CameraDepthTexture, sPos);
			float4 Depth = tex2D(_MainTex, sPos);
			o.Emission = Depth.rgb;
        }
        ENDCG
    }
    FallBack off
}
