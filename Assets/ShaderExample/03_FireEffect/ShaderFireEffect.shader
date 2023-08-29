Shader "KCH/03_FireEffect"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "magenta" {}
        _MainTex2 ("Albedo (RGB)", 2D) = "magenta" {}
    }
    SubShader
    {
        // fade: 깔끔하게 나옴 1~0 까지 모든 값을 적용시켜줌
        // transparent 마찬가지
        // cutoff는 1이 아니면 다 잘라냄
        // 큐는 렌더큐라고 하며 우리가 아는 그 자료구조의 큐다.
        // 큐가 있는 이유는 렌더링 순서 때문이다.
        // 반투명은 뒤에 녀석이 보인다는 의미이고 이는 즉 뒤에 녀석이 먼저 그려지고 그 위에 덧그려져야 한다는 의미이다.
        // 그래서 얘는 먼저 뒤에 녀석을 그리고 나중에 저를 그려주세요 하는 이유로 큐에 넣는다.
        // 렌더 큐에서 "transparent"는 3000이다
        // "Transparent + 1"로 적으면 3001이 된다.
        // 이런 렌더 큐 문제로 생기는 골치아픈 일들이 종종 발생한다.
        // 번호가 큰게 나중에 그려진다.

        // 풀의 경우 매쉬가 네모다
        // 그래서 얘는 fade나 Transparent로 만들면 그림자가 박스다
        // 불투명한 그림자를 만들려면 그림자 만들고 알파랑 비교하고 해야해서
        // 그런데 cutoff는 그림자가 이쁘게 나온다.

		Tags { "RenderType" = "Transparent" "Queue" = "Transparent" }

        // fade를 명령해줘야 그래픽카드가 알파 테스트를 해준다.
        // 이렇게 디폴트로 안해주는 이유가 알파 테스트는 비싸기 때문임.
        // 그니까 Alpha값이 들어갔다고 해서 투명해지지는 않는다.
        // 우리가 코드로 짤 때는 tags와 alpha:fade 둘 다 해줘야 한다.

        CGPROGRAM

        // 여기서 fade까지 해줘야 한다.
        #pragma surface surf Standard alpha:fade

        sampler2D _MainTex;
        sampler2D _MainTex2;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            // _Time은 유니티에서 제공하는 키워드다.
            // _Time.x 는 시간/20, z는 *2 w는 *3
            // 말고도 _SineTime 등 있다. 찾아봐도 좋을듯
            fixed4 c2 = tex2D (_MainTex2, float2(IN.uv_MainTex.x, IN.uv_MainTex.y - _Time.z));

            // 색이 더해지는 것과 곱해지는 것은 다르다.
            // 더해지면 최대값이 1이라서 거의 무조건 흰색이 나온다.
            // 곱하면 두 값의 중간값이 나온다.
            o.Emission = c.rgb * c2.rgb;

            // 알파 블렌딩은 우리가 비율가지고 조절을 하는거임.
            // 알파 테스트로 하려면 이렇게 실제로 알파값을 넣어줘야함.
            // 우리가 알파 테스트를 해주세요 했는데 알파값이 0이면 그리지 않기 때문에 안그려진다.
			

            if(c.a > 0)
                o.Alpha = c2.r;
            else
                o.Alpha = 0;

             // 이렇게 하면 연기만 보임
             // 만약 배경을 불로 해두고 칼에 이글거리는 효과를 넣으면 불이 이글거리게 할 수 있겠다
             // 칼을 가져오면 칼 모양 불이겠다.
             // 불이 파란색이면 파란 불의 칼이겠다.
        }
        ENDCG
    }
    FallBack "Diffuse"
}
