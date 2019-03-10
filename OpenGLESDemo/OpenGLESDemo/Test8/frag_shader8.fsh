varying lowp vec2 varyTextCoord;
uniform sampler2D colorMap;     //2d纹理d采样器，默认的激活纹理单元(0)，没有分配值
void main()
{
    gl_FragColor = texture2D(colorMap, varyTextCoord); //采样的纹理颜色，第一个参数是纹理采样器，第二个参数是纹理坐标
}
