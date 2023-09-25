Shader "Unlit/bbg"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Amp ("Amplitude", Range(-1, 1)) = 0.1
        _Freq ("Frequency", Range(-10, 10)) = 1
        _Scale ("Scale", Range(-19, 10)) = 1
        _Comp ("Compression", Range(-1, 1)) = 0.5
        _Mode ("Mode", Range(0, 4)) = 0
        _Blend ("Blend Mode", Range(0, 5)) = 0
        _Opacity ("Opacity", Range(0, 1)) = 1
        _XTrans ("X Offset", Range(-1, 1)) = 0
        _YTrans ("Y Offset", Range(-1, 1)) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100
        ZWrite Off

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            float _Amp;
            float _Freq;
            float _Scale;
            float _Comp;
            float _Mode;
            float _Blend;
            float _Opacity;
            float _XTrans;
            float _YTrans;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);

                float distx = _Amp * sin(_Freq * i.uv.y + (_Scale * _Time.y));

                float2 offset = float2(_XTrans, _YTrans);
                float y = i.uv.y * 180;

                if (_Mode == 0.0)
                {
                    offset.x += distx;
                }
                else if (_Mode == 1.0)
                {
                    if(int(y % 2) == 0 ) 
                    {
                        offset.x += distx;
                    }
                    else
                    {
                        offset.x += -distx;
                    }
                }
                else if (_Mode == 2.0)
                {
                    offset.y += i.uv.y * _Comp + distx;
                }
                else if (_Mode == 3.0)
                {
                    offset.x += distx;
                    offset.y += i.uv.y * _Comp + distx;
                }
                else if (_Mode == 4.0)
                {
                    if(int(y % 2) == 0 ) 
                    {
                        offset.x += distx;
                    }
                    else
                    {
                        offset.x += -distx;
                    }
                    offset.y += i.uv.y * _Comp + distx;
                }

                float2 uv = i.uv + offset;
                col = tex2D(_MainTex, uv);
                
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
