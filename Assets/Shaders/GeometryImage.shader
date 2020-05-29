Shader "GeometryImage/Custom" {
    Properties{
        _Color("Main Color", Color) = (1,1,1,0.5)
        _MainTex("Texture", 2D) = "white" { }
        _NormalTex("Normal Texture", 2D) = "white" { }
    }
        SubShader{
            Pass {

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            fixed4 _Color;
            sampler2D _MainTex;
            sampler2D _NormalTex;
            float _GridSize;
            float _GridCount;
            float4x4 _ObjectToWorld;

            struct v2f {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : TEXCOORD1;
            };

            float4 _MainTex_ST;

            v2f vert(appdata_base v, uint id : SV_VertexID, uint instanceID : SV_InstanceID)
            {
                uint count = (uint)_GridCount;

                uint x = instanceID % count;
                uint z = instanceID / count;
                float2 points[4];
                points[0] = float2(x * _GridSize, z * _GridSize);
                points[1] = points[0] + float2(_GridSize, 0);
                points[3] = points[0] + float2(0, _GridSize);
                points[2] = points[0] + float2(_GridSize, _GridSize);

                float invChunkSize = 1 / (_GridSize * _GridCount);
                float4 uv = float4(points[id].x * invChunkSize, points[id].y * invChunkSize, 0, 0);
                float3 pos = tex2Dlod(_MainTex, uv).xyz;
                float3 normal = tex2Dlod(_NormalTex, uv).xyz;
                float4 worldPos = mul(_ObjectToWorld, float4(pos, 1));
                v2f o;
                o.pos = mul(UNITY_MATRIX_VP, worldPos);
                o.uv = uv.xy;
                o.normal = mul(_ObjectToWorld, float4(normal, 1));
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float3 dir = _WorldSpaceLightPos0.xyz;
                float ndotl = saturate(dot(i.normal, dir));
                fixed4 texcol = _Color * ndotl;
                return texcol;
            }
            ENDCG

            }
    }
}