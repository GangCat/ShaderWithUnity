Shader "KCH/02_ShaderTexture"
{
    Properties
    {
        // 2d형식의 텍스쳐를 불러오는 핸들
        // black은 텍스쳐가 들어오지 않았을 때 사용할 색상. 보통은 마젠타를 씀
        // 첫번째로 받아오는 텍스쳐의 핸들명은 반드시 _MainTex이어야함
        // 두번째부터는 마음대로 하면 됨
        // 안넣으면 색상 마젠타도 아니고 그냥 이상하게 나옴.
        _MainTex ("Albedo (RGB)", 2D) = "magenta" {}
        _MainTexTo ("Albedo (RGB)", 2D) = "magenta" {}
        _MainTex3 ("Tex3", 2D) = "magenta" {}
        _AlphaMap ("Alpha Map", 2D) = "magenta" {}
        _Ratio ("Ratio", Range(0, 1)) = 0
    }
    SubShader
    {
        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        // 서페이스를 돌릴건데 함수명은 surf고 스탠다드를 사용할거다.
        // fullforwardshadows는 그림자를 처리할 것이다 라는 의미.
        // 유니티한테 뭐 조명 빼주세요, 그림자느 ㄴ이렇게 표시해주세요를 할 때 저기에 적는다.
        // 그림자를 전부 계산해주세요하는 의미임 저거는 

        // uv좌표를 이용해 gpu에 바인딩되어있는 텍스처의 픽셀 정보를 가져오는게 샘플러
        // 인형뽑기할 때의 그 로봇 팔이라고 생각해도 될듯
        sampler2D _MainTex;
        sampler2D _MainTexTo;
        sampler2D _MainTex3;
        sampler2D _AlphaMap;

        fixed _Ratio;
        
        // 샘플러가 픽셀정보를 가져오기 위해서는 해당 uv 좌표를 가져와야 하기 때문에
        // Input이 uv좌표이다.
        struct Input
        {
            float2 uv_MainTex; // 이것도 고정
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
			float4 texColor = tex2D (_MainTex, IN.uv_MainTex);
			float4 texToColor = tex2D (_MainTexTo, IN.uv_MainTex);
            float4 tex3Color = tex2D(_MainTex3, IN.uv_MainTex);
            float4 alphaColor = tex2D(_AlphaMap, IN.uv_MainTex);
			//o.Albedo = texColor.rgb;
            //o.Emission = texColor.rgba;
            // o.Emission = texColor.r; -> 흑백연출 근데 별로 이쁘진 않음.
            // o.Emission = texColor.bgra; -> 반전색상연출
            // 이렇게 색상만 변경하는 것으로 표현하는 것을 스위즐링
            // 흑백을 좀 이쁘게 하는 것을 그레이스케일이라고 한다.
            // 그 방법이 바로 아래의 방법이다.
            //o.Emission = texColor.r * 0.2989 + texColor.g * 0.5870 + texColor.b * 0.1140;
    
            // 꺼낸 초록값이 0.8보다 크면, 많이 초록색이면 붉은색으로 변경
            //if(texColor.g > 0.8)
            //    o.Emission = fixed4(1, 0, 0, 1);
            //else
            //    o.Emission = texColor;
    
            //fixed4 backColor = fixed4(0, 0, 0, 1) * (_Ratio) + texToColor * (1 - _Ratio);
    
            // 이렇게 하면 링크는 그대로 있고 배경만 사라지게 만들 수 있다. 그것도 서서히
            // ㅈㄴ 재밌음
    
            //if(texColor.a > 0)
            //    o.Emission = tex3Color;
            //else
            //    o.Emission = backColor;        
            // 마치 링크를 투명화한거임.
    
            o.Emission = lerp(texColor, texToColor, alphaColor.r);
            // 마지막의 맵이 알파맵이면 해당 맵의 알파값을 기준으로 두 그림의 색을 블렌딩해줌.
            // 알파블렌딩을 하려면 뒤에꺼가 먼저 그려져야함.
        }
        ENDCG
    }
    FallBack "Diffuse"
}
