Shader "KCH/07_Hologram"
{
    // 홀로그램은 림라이트만 그려놓은거임
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _BumpMap ("Normal Map (RGB)", 2D ) = "bump" {}
    }
    SubShader
    {
        Tags { "RenderType" = "Transparent" "Queue" = "Transparent" }

        CGPROGRAM
        #pragma surface surf Lambert noambient alpha:fade
        // 엠비언트 조명 모델중 하나
        // 모델 종류
        // 1. 디퓨즈: 난반사광, 원래 물체의 색
        // 2. 스펙큘러: 집중광, 광원이 왔을 때 제일 빛이 많이 비추는 곳을 강조하는 것
        // 3. 엠비언트: 주변광, 예전에는 글로벌 일루미네이션이 없었음
        // 그래서 주변에서 들어오는 색상을 임의로 지정해주는 것이 바로 엠비언트
        // 글로벌 일루미네이션에서 들어오는 색이랑은 약간 다름

        // 디퓨즈는 명암이 들어감
        // 스펙큘러는 집중되는 위치에만 빛이 들어가고 명암이 계산됨
        // 엠비언트는 그냥 색을 추가해주는 느낌, 그래서 명암이 없음
        // 엠비언트는 기본적으로 들어간다 그래서 필요없으면 꺼야한다

        sampler2D _MainTex;
        sampler2D _BumpMap;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
			float3 viewDir;

            float3 worldPos;
            // 해당 픽셀이 월드에서 어떤 포지션에 존재하는지를 가져온다.
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
            o.Albedo = c.rgb;

            // 월드 포지션으로 
			//o.Emission = float3(0, 1, 0);
            //o.Emission = IN.worldPos.rgb;
            //o.Emission = IN.worldPos.g;
            //o.Emission = frac(IN.worldPos.g);
            //o.Emission = pow(frac(IN.worldPos.g), 30);
            //o.Emission = pow(frac(IN.worldPos.g * 3), 30);
            //o.Emission = pow(frac(IN.worldPos.g * 3 - _Time.y), 30);
            o.Emission = pow(frac(IN.worldPos.g * 3 - _Time.y), 30);

			float rim = saturate(dot(o.Normal, IN.viewDir));
			rim = pow(1 - rim, 3);
            
            // 깜빡거리게 만들기
            //o.Alpha = rim;
            //o.Alpha = rim * (sin(_Time.y) * 0.5 + 0.5);
            o.Alpha = rim * abs(sin(_Time.y));
            //o.Alpha = 1;

            // 전체를 초록으로 칠하고 alpha를 조절해서 가운데만 투명하게 하는 것
        }
        ENDCG
    }
    FallBack "Diffuse"
}
