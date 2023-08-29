Shader "KCH/11_Cubemap"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_BumpMap ("NormalMap", 2D) = "bump" {}
		// 이렇게 만들어지는 매핑을 환경매핑이라고 함.
		// 검색할때도 environment mapping이라고 검색해야함
		// 내가 바라보는 방향과 오브젝트의 노말을 계산해서 반사되는 그 위치의 큐브맵의 픽셀 색을 가져와서 입힘
		// 큐브맵을 쓸때는 2D가 아니라 Cube로 쓰면 된다
		_Cube ("CubeMap", Cube) = "" {}

		// 메탈릭으로 반사되는건 글로벌 일루미네이션이 적용되는거고 난반사광이 들어오는거라서 비용이 훨씬 비쌈
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
		
		CGPROGRAM
		#pragma surface surf Lambert noambient

		sampler2D _MainTex;
		sampler2D _BumpMap;
		samplerCUBE _Cube;

		struct Input
        {
            float2 uv_MainTex;
			float2 uv_BumpMap;
			// 원래 반사벡터를 우리가 구해야하는데 이걸 얘가 가져다줌, 지금 찍을 픽셀의 반사벡터
			float3 worldRefl;
			// 월드 반사벡터나 월드 노멀벡터를 사용하려면 INTERNAL_DATA가 반드시 필요하다

			// 우리가 기본적으로 노멀벡터는 각 정점에 저장되는 것이라는 사실을 알고있다.
			// 환경매핑은 픽셀당으로 돌아감
			// 그래서 버텍스가 가지고 있는 노말가지고는 계산할 수 없음
			// 그래서 INTERNAL_DATA가 필요함
			INTERNAL_DATA
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
			o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
			// texCUBE에서 샘플러는 큐브, worldreflectionvector를 구하기 위해서 IN과 o.Normal이 필요하다.
			// 그 정보를 Input 구조체에서 가져오고 이렇게 IN만 해주면 된다
			float4 re = texCUBE(_Cube, WorldReflectionVector(IN, o.Normal));
			o.Albedo = c.rgb * 0.5;
			// 반사된 애들은 명암이 당연히 안들어가니까 emission으로 들어가고 albedo랑 섞으려고 0.5씩 곱해줌
			o.Emission = re.rgb * 0.5;
			o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
