//
//  WztTest14VC.m
//  OpenGLESDemo
//
//  Created by tyler on 4/25/19.
//  Copyright © 2019 wzt. All rights reserved.
//

#import "WztTest14VC.h"
#import "esTransform.h"

static GLfloat const angle_offset = 0.1;

@interface WztTest14VC () {
    
    GLint maPositionHandle;
    GLint muMVPMatrixHandle;
    GLint maTexCoorHandle;
    
    GLuint texId;
    
    GLfloat angle_varing;
}

@end

@implementation WztTest14VC

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    self.view.backgroundColor = [UIColor whiteColor];
    
    //
    angle_varing = 0.0f;
    [self openglesInit];
}

#pragma mark private methods
-(void)openglesInit {
    
    //#version 300 es           //\
    
    NSString *vShaderStr =
    @"uniform mat4 uMVPMatrix;    \
    attribute vec3 aPosition;   \
    attribute vec2 aTexCoor;    \
    varying vec2 vTextureCoord; \
    void main()                 \
    {                           \
        gl_Position = uMVPMatrix * vec4(aPosition,1);\
        vTextureCoord = aTexCoor; \
    }";
    
    //#version 300 es                                                   //\
    
    NSString *fShaderStr =
    @"precision mediump float;                                          \
    varying vec2 vTextureCoord;                                         \
    uniform sampler2D sTexture;                                         \
    void main()                                                         \
    {                                                                   \
                                                                        \
        vec2 offset0=vec2(-1.0,-1.0); vec2 offset1=vec2(0.0,-1.0); vec2 offset2=vec2(1.0,-1.0);     \
        vec2 offset3=vec2(-1.0,0.0); vec2 offset4=vec2(0.0,0.0); vec2 offset5=vec2(1.0,0.0);        \
        vec2 offset6=vec2(-1.0,1.0); vec2 offset7=vec2(0.0,1.0); vec2 offset8=vec2(1.0,1.0);        \
        const float scaleFactor=1.0/9.0;                                                            \
                                                                                                    \
                                                                                                    \
        float kernelValue0 = 1.0; float kernelValue1 = 1.0; float kernelValue2 = 1.0;               \
        float kernelValue3 = 1.0; float kernelValue4 = 1.0; float kernelValue5 = 1.0;               \
        float kernelValue6 = 1.0; float kernelValue7 = 1.0; float kernelValue8 = 1.0;               \
                                                                                                    \
        vec4 sum;                                                                                   \
        vec4 cTemp0,cTemp1,cTemp2,cTemp3,cTemp4,cTemp5,cTemp6,cTemp7,cTemp8;    \
        cTemp0=texture2D(sTexture, vTextureCoord.st + offset0.xy/512.0);        \
        cTemp1=texture2D(sTexture, vTextureCoord.st + offset1.xy/512.0);        \
        cTemp2=texture2D(sTexture, vTextureCoord.st + offset2.xy/512.0);        \
        cTemp3=texture2D(sTexture, vTextureCoord.st + offset3.xy/512.0);        \
        cTemp4=texture2D(sTexture, vTextureCoord.st + offset4.xy/512.0);        \
        cTemp5=texture2D(sTexture, vTextureCoord.st + offset5.xy/512.0);        \
        cTemp6=texture2D(sTexture, vTextureCoord.st + offset6.xy/512.0);        \
        cTemp7=texture2D(sTexture, vTextureCoord.st + offset7.xy/512.0);        \
        cTemp8=texture2D(sTexture, vTextureCoord.st + offset8.xy/512.0);        \
                                                                                \
        sum =kernelValue0*cTemp0+kernelValue1*cTemp1+kernelValue2*cTemp2+       \
        kernelValue3*cTemp3+kernelValue4*cTemp4+kernelValue5*cTemp5+            \
        kernelValue6*cTemp6+kernelValue7*cTemp7+kernelValue8*cTemp8;            \
        gl_FragColor=sum*scaleFactor;             \
    }" ;
    
    // Create the program object
    const char *vertex_shader_string = [vShaderStr UTF8String];
    const char *fragment_shader_string = [fShaderStr UTF8String];
    programObject = esLoadProgram ( vertex_shader_string, fragment_shader_string );
    
    if ( programObject == 0 ) {
        NSLog(@"Create Program failed.");
        return;
    }
    
    //可以设置背景色
    glClearColor(0.3f, 0.6f, 1.0f, 1.0f);
    
    //获取程序中顶点位置属性引用
    maPositionHandle = glGetAttribLocation(programObject, "aPosition");
    //获取程序中总变换矩阵id
    muMVPMatrixHandle = glGetUniformLocation(programObject, "uMVPMatrix");
    //获取程序中顶点纹理坐标属性引用
    maTexCoorHandle= glGetAttribLocation(programObject, "aTexCoor");
    
    //传递被按下的图片id
    if (texId) {
        glDeleteTextures(1, &texId);
    }
    //生成纹理id
    texId = [self setupTexture:@"moguPic"];
    glBindTexture(GL_TEXTURE_2D, texId);
}

//初始化纹理
- (GLuint)setupTexture:(NSString *)fileName {
    //1 获取图片的CGImageRef
    CGImageRef spriteImage = [UIImage imageNamed:fileName].CGImage;
    if (!spriteImage) {
        NSLog(@"Failed to load image %@", fileName);
        exit(1);
    }
    
    //2 读取图片的大小
    size_t width = CGImageGetWidth(spriteImage);
    size_t height = CGImageGetHeight(spriteImage);
    
    GLubyte * spriteData = (GLubyte *) calloc(width * height * 4, sizeof(GLubyte)); //rgba共4个byte
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4,
                                                       CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);
    
    //3 在CGContextRef上绘图
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
    
    CGContextRelease(spriteContext);
    
    
    //4 绑定纹理到默认的纹理ID（这里只有一张图片，故而相当于默认于片元着色器里面的colorMap，如果有多张图不可以这么做）
    GLuint texture;
    glGenTextures(1, &texture);
    glBindTexture(GL_TEXTURE_2D, texture);
    
    //为当前绑定的纹理对象设置 环绕、过滤 方式
    //非Mipmap纹理采样过滤参数
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    //ST方向纹理拉伸方式
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
    
    //生成纹理
    float fw = width, fh = height;
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, fw, fh, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    
    free(spriteData);
    
    return texture;
}

-(void)drawGL:(GLfloat)angle {
   
    // Set the viewport
    glViewport ( 0, 0, window_width, window_height );
    // Clear the color buffer
    glClear ( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );
    
    glUseProgram(programObject);
    
    
    //矩阵
    ESMatrix currMatrix, mVMatrix, mProjMatrix;
    esMatrixLoadIdentity ( &currMatrix );
    esMatrixLoadIdentity ( &mVMatrix );
    esMatrixLoadIdentity ( &mProjMatrix );
    
    //GLfloat angle = 45.0;
    esRotate ( &currMatrix, angle, 1.0, 0.0, 1.0 );
    
    ESMatrix mMVPMatrix;
    esMatrixMultiply ( &mMVPMatrix, &mVMatrix, &currMatrix );
    esMatrixMultiply ( &mMVPMatrix, &mProjMatrix, &mMVPMatrix );
    
    //将最终变换矩阵传入着色器程序
    glUniformMatrix4fv(muMVPMatrixHandle, 1, 0, &mMVPMatrix.m[0][0]);
    
    //将顶点纹理坐标数据传入渲染管线
    float tEnd=1.0, sEnd=1.0;
    float vertexVertices[]= //纹理坐标
    {
        0,0, 0,tEnd, sEnd,0,
        0,tEnd, sEnd,tEnd, sEnd,0
    };
    glVertexAttribPointer(maTexCoorHandle, 2, GL_FLOAT, 0, 0, vertexVertices);
    
    //启用顶点位置数据
    glEnableVertexAttribArray(maPositionHandle);
    glEnableVertexAttribArray(maTexCoorHandle);
    
    
    //绑定纹理
    glActiveTexture(GL_TEXTURE0);
    
//    //传递被按下的图片id
//    //生成纹理id
//    texId = [self setupTexture:@"moguPic"];
//    glBindTexture(GL_TEXTURE_2D, texId);
    
    //将顶点法向量传入渲染管线
    float mVertexBuffer[]=
    {
        -0.5f, 0.5f, 0,
        -0.5f, -0.5f, 0,
        0.5f, 0.5f, 0,
        
        -0.5f, -0.5f, 0,
        0.5f, -0.5f, 0,
        0.5f, 0.5f, 0,
    };
    glVertexAttribPointer(maPositionHandle, 3, GL_FLOAT, 0, 0, mVertexBuffer);
    
    
    
    //绘制
    int vCount = 6;
    glDrawArrays(GL_TRIANGLES, 0, vCount);
    
//    glDeleteTextures(1, &texId);
}




#pragma mark overwrite methods
/**
 *  渲染场景代码
 */
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    [super glkView:view drawInRect:rect];
    
    //glClear ( GL_COLOR_BUFFER_BIT );
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
   
    
    
    //自定义代码
    //angle_varing += angle_offset;
    [self drawGL:angle_varing];
}

-(void)dealloc {

    NSLog(@"哦，天呢，你都干了什么，内存超载了....");
    glClearColor(0.0, 0.0, 0.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
}

@end
