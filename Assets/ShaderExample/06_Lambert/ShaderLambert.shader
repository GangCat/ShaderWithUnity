Shader "KCH/06_Lambert"
{
	// lambert 조명모델
	// 우리가 아는 그 노말이랑 그렇게해서 그렇게하는거
	// standard는 물리기반이라 무겁고 얘는 각도만 계산해서 가벼움 훨씬
	// 우리가 직접 조명을 계산하는 것
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_BumpMap ("NormalMap", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

		// 조명을 우리가 만든 Test라는 조명모델을 사용하겠다는 의미
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
			o.Alpha = c.a;
        }
		// 직접 조명을 계산하는 쉐이더 코드
		// 이름은 Lighting"Test" 여기 뒤에 붙는 이름을 넣어야함
		// 이렇게 하는 방법을 커스터마이팅이라고 한다.
		// 조명을 직접 계산하는 것
		// 매개변수와 반환형은 고정이다.
		// 여기서 반환되는 플롯4가 최종적으로 찍히는 픽셀이다.
		// 위 surf에서 조작한 surfaceOutput이 여기에 들어옴.
		// lightDir은 유니티에 세팅되어있는 조명
		// atten은 빛의 감쇄를 말한다.
		float4 LightingTest (SurfaceOutput s,
		                     float3 lightDir,
							 float atten) {
			// 언팩한 노말이랑 조명이랑 내적을 구함.
			// 근데 이렇게 하면 -1부터1까지 나옴
			// 이걸 0부터 1까지로 바꿔주는게 saturate
			// 변수 이름은 NormalDotLight 줄임말
			float ndotl = saturate(dot(s.Normal, lightDir));
			// 최종적으로 사용할 플롯4
			float4 final;
			// 계산한 조명 * 
			// 지금 찍을 픽셀의 원래 텍스쳐의 색 * 
			// 지금 비춰지는 조명의 색상(전역으로 존재하는 변수임, 0은 디렉셔널 라이트) 얘가 빠지면 그냥 밝다 어둡다만 보임*
			// attenuation(감쇄) 우리가 이걸 어떻게할 수는 없음.
			// 조명은 다가올수록 서서히 밝아지는게 보통이다.
			// 그런데 감쇄가 적용이 안되면 빛이 갑자기 사라지고 갑자기 나타난다.
			// 만일 디아블로같이 빛이 평생 같은 세기로 같은 방향이면 딱히 곱할 필요없음
			final.rgb = ndotl * s.Albedo * _LightColor0.rgb * atten;
			// 알파는 위에서 계산한 그 알파값
			final.a = s.Alpha;
			return final;
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