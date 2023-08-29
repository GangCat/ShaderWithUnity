Shader "KCH/09_NPR2Pass"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        
        Tags { "RenderType"="Opaque" }

        // 앞면을 컬링해서 뒷면만 보여야하기 때문에 컬링을 front로 설정한다.
		cull front

        // 패스는 CGPROGRAM을 기준으로 구별한다.
		// Pass 1
        CGPROGRAM
        // 조명계산도 Nolight로 우리가 할거고 버텍스 쉐이더를 처리할 함수 이름을 vert로 할거고 그림자랑 엠비언트 다 필요없다
        #pragma surface surf Nolight vertex:vert noshadow noambient

        // appdate_full
        // 버텍스 쉐이더를 처리하는 과정에서 들어오는 모든 것(버텍스 위치, 노말벡터, uv위치, 버텍스 컬러)을 다 가져온다는 의미
		void vert(inout appdata_full v) {
            // 버텍스의 위치를 바꾸겠다.
            // 우리가 받아온 버텍스의 노말방향으로 0.01만큼 더 올리겠다는 의미
			v.vertex.xyz += v.normal.xyz * 0.001;
            
		}

        struct Input { float4 color:COLOR; };

        // 실제로 컬러를 처리할 것이 아니라 Input IN이 필수라서 그냥 만들어주기만 함.
        void surf (Input IN, inout SurfaceOutput o) {}

        // 우리가 커스텀 라이팅을 계산하는 함수지만 실제로는 그냥 검은색으로 그리기 위해서 함수를 호출함
		float4 LightingNolight (SurfaceOutput s, float3 lightDir, float atten) {
			return float4(1, 0, 0, 1);
		}
		ENDCG

        // 다시 컬링 원상복구
		cull back

        // 그냥 원래대로 그려줌
        // pass2
		CGPROGRAM
		#pragma surface surf Lambert

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
        ENDCG
    }
    FallBack "Diffuse"
}
