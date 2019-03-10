attribute vec4 position;      //输入参数1 (位置坐标)
attribute vec2 textCoordinate;//输入参数2 (纹理坐标)
uniform mat4 rotateMatrix;    //全局参数
varying lowp vec2 varyTextCoord;//纹理坐标
void main()
{
    //解决纹理上下颠倒问题
    varyTextCoord = vec2(textCoordinate.x, 1.0-textCoordinate.y);
    gl_Position = position * rotateMatrix;
}

