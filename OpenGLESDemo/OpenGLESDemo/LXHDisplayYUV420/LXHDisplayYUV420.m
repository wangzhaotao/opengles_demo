//
//  LXHDisplayYUV420.m
//  OpenGLESDemo
//
//  Created by tyler on 4/20/19.
//  Copyright © 2019 wzt. All rights reserved.
//

/*
---------------------
作者：雷霄骅
来源：CSDN
原文：https://blog.csdn.net/leixiaohua1020/article/details/40379845
版权声明：本文为博主原创文章，转载请附上博文链接！
*/

/**
 * 最简单的OpenGL播放视频的例子（OpenGL播放YUV）[Texture]
 * Simplest Video Play OpenGL (OpenGL play YUV) [Texture]
 *
 * 雷霄骅 Lei Xiaohua
 * leixiaohua1020@126.com
 * 中国传媒大学/数字电视技术
 * Communication University of China / Digital TV Technology
 * http://blog.csdn.net/leixiaohua1020
 *
 * 本程序使用OpenGL播放YUV视频像素数据。本程序支持YUV420P的
 * 像素数据作为输入，经过转换后输出到屏幕上。其中用到了多种
 * 技术，例如Texture，Shader等，是一个相对比较复杂的例子。
 * 适合有一定OpenGL基础的初学者学习。
 *
 * 函数调用步骤如下:
 *
 * [初始化]
 * glutInit(): 初始化glut库。
 * glutInitDisplayMode(): 设置显示模式。
 * glutCreateWindow(): 创建一个窗口。
 * glewInit(): 初始化glew库。
 * glutDisplayFunc(): 设置绘图函数（重绘的时候调用）。
 * glutTimerFunc(): 设置定时器。
 * InitShaders(): 设置Shader。包含了一系列函数，暂不列出。
 * glutMainLoop(): 进入消息循环。
 *
 * [循环渲染数据]
 * glActiveTexture(): 激活纹理单位。
 * glBindTexture(): 绑定纹理
 * glTexImage2D(): 根据像素数据，生成一个2D纹理。
 * glUniform1i():
 * glDrawArrays(): 绘制。
 * glutSwapBuffers(): 显示。
 *
 * This software plays YUV raw video data using OpenGL.
 * It support read YUV420P raw file and show it on the screen.
 * It's use a slightly more complex technologies such as Texture,
 * Shaders etc. Suitable for beginner who already has some
 * knowledge about OpenGL.
 *
 * The process is shown as follows:
 *
 * [Init]
 * glutInit(): Init glut library.
 * glutInitDisplayMode(): Set display mode.
 * glutCreateWindow(): Create a window.
 * glewInit(): Init glew library.
 * glutDisplayFunc(): Set the display callback.
 * glutTimerFunc(): Set timer.
 * InitShaders(): Set Shader, Init Texture. It contains some functions about Shader.
 * glutMainLoop(): Start message loop.
 *
 * [Loop to Render data]
 * glActiveTexture(): Active a Texture unit
 * glBindTexture(): Bind Texture
 * glTexImage2D(): Specify pixel data to generate 2D Texture
 * glUniform1i():
 * glDrawArrays(): draw.
 * glutSwapBuffers(): show.
 */

#import "LXHDisplayYUV420.h"
#include <stdio.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import <OpenGLES/EAGL.h>
#include <sys/time.h>

//Select one of the Texture mode (Set '1'):
#define TEXTURE_DEFAULT   0
//Rotate the texture
#define TEXTURE_ROTATE    0
//Show half of the Texture
#define TEXTURE_HALF      1

const int screen_w=500,screen_h=500;
const int pixel_w = 320, pixel_h = 280;
//YUV file
FILE *infile = NULL;
unsigned char buf[pixel_w*pixel_h*3/2];
unsigned char *plane[3];


GLuint p;
GLuint id_y, id_u, id_v; // Texture id
GLuint textureUniformY, textureUniformU,textureUniformV;


#define ATTRIB_VERTEX 3
#define ATTRIB_TEXTURE 4


//Shader.vsh
const char vShaderStr_lxh[] = "#version 300 es  \n"
"attribute vec4 vertexIn;                       \n"
"attribute vec2 textureIn;                      \n"
"varying vec2 textureOut;                       \n"
"void main(void)                                \n"
"{                                              \n"
"    gl_Position = vertexIn;                    \n"
"    textureOut = textureIn;                    \n"
"}                                              \n";

//Shader.fsh
const char fShaderStr_lxh[] = "#version 300 es     \n"
"varying vec2 textureOut;                          \n"
"uniform sampler2D tex_y;                          \n"
"uniform sampler2D tex_u;                          \n"
"uniform sampler2D tex_v;                          \n"
"void main(void)                                   \n"
"{                                                 \n"
"    vec3 yuv;                                     \n"
"    vec3 rgb;                                     \n"
"    yuv.x = texture2D(tex_y, textureOut).r;       \n"
"    yuv.y = texture2D(tex_u, textureOut).r - 0.5; \n"
"    yuv.z = texture2D(tex_v, textureOut).r - 0.5; \n"
"    rgb = mat3( 1,       1,         1,            \n"
"               0,       -0.39465,  2.03211,       \n"
"               1.13983, -0.58060,  0) * yuv;      \n"
"    gl_FragColor = vec4(rgb, 1);                  \n"
"}                                                 \n";



@interface LXHDisplayYUV420 ()
{
    int pixel_w;
    int pixel_h;
    
    EAGLContext *glContext;
    CAEAGLLayer *eaglLayer;
    
    /**
     帧缓冲区
     */
    GLuint                  _framebuffer;
    
    /**
     渲染缓冲区
     */
    GLuint                  _renderBuffer;
    
    GLsizei                 _viewScale;
}

@end


@implementation LXHDisplayYUV420


-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self setupContext];
        InitShaders();
    }
    return self;
}
+ (Class)layerClass
{
    return [CAEAGLLayer class];
}
-(void)layoutSubviews {
    
}
- (void)initFrameAndRenderBuffer{
    CAEAGLLayer *eaglLayer=(CAEAGLLayer *)self.layer;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //互斥锁
        @synchronized (self) {
            [EAGLContext setCurrentContext:self->glContext];
            //创建缓冲区
            [self createFrameAndRenderBuffer:eaglLayer];
        }
        
        
        //把数据显示在这个视窗上
        dispatch_async(dispatch_get_main_queue(), ^{
            glViewport(0, 0, self.bounds.size.width*self->_viewScale, self.bounds.size.height*self->_viewScale);
        });
    });
}

//创建EAGLContext
-(void)setupContext {
    
    //创建一个OpenGLES 2.0接口的context
    EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES2;
    glContext = [[EAGLContext alloc]initWithAPI:api];
    if (!glContext) {
        NSLog(@"Failed to create to OPENGLES 2.0 context.");
        exit(0);
    }
    //将其设置为current context
    if (![EAGLContext setCurrentContext:glContext]) {
        NSLog(@"Failed to set current OpenGL context.");
    }
    
    eaglLayer = (CAEAGLLayer*) self.layer;
    //CAEAGLLayer默认是透明的，这会影响性能，所以将它设为不透明
    eaglLayer.opaque = YES;
    eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking,
                                     kEAGLColorFormatRGB565, kEAGLDrawablePropertyColorFormat,
                                     //[NSNumber numberWithBool:YES], kEAGLDrawablePropertyRetainedBacking,
                                     nil];
    
    _viewScale = [UIScreen mainScreen].scale;
}

/**
 创建缓冲区
 */
- (BOOL)createFrameAndRenderBuffer:(CAEAGLLayer *)eaglLayer
{
    //创建帧缓冲绑定
    glGenFramebuffers(1, &_framebuffer);
    //创建渲染缓冲
    glGenRenderbuffers(1, &_renderBuffer);
    
    //将之前用glGenFramebuffers创建的帧缓冲绑定为当前的Framebuffer(绑定到context上？).
    glBindFramebuffer(GL_FRAMEBUFFER, _framebuffer);
    //Renderbuffer绑定到context上,此时当前Framebuffer完全由renderbuffer控制
    glBindRenderbuffer(GL_RENDERBUFFER, _renderBuffer);
    
    //分配空间
    if (![glContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:eaglLayer])
    {
        NSLog(@"attach渲染缓冲区失败");
    }
    
    //这个函数看起来有点复杂，但其实它很好理解的。它要做的全部工作就是把把前面我们生成的深度缓存对像与当前的FBO对像进行绑定，当然我们要注意一个FBO有多个不同绑定点，这里是要绑定在FBO的深度缓冲绑定点上。
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _renderBuffer);
    
    //检查当前帧缓存的关联图像和帧缓存参数
    if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE)
    {
        NSLog(@"创建缓冲区错误 0x%x", glCheckFramebufferStatus(GL_FRAMEBUFFER));
        return NO;
    }
    return YES;
}

-(void)setVideoWitdth:(GLuint)width height:(GLuint)height {
    
    //给宽高赋值
    pixel_w = height;
    pixel_h = width;
    
    //开辟内存空间
    //为什么乘1.5而不是1: width * hight =Y（总和） U = Y / 4   V = Y / 4
    void *blackData = malloc(width * height * 1.5);
    
    if (blackData) {
        memset(blackData, 0x0, width * height * 1.5);
    }
    /*
     Apple平台不允许直接对Surface进行操作.这也就意味着在Apple中,不能通过调用eglSwapBuffers函数来直接实现渲染结果在目标surface上的更新.
     在Apple平台中,首先要创建一个EAGLContext对象来替代EGLContext (不能通过eglCreateContext来生成), EAGLContext的作用与EGLContext是类似的.
     然后,再创建相应的Framebuffer和Renderbuffer.
     Framebuffer象一个Renderbuffer集(它可以包含多个Renderbuffer对象).
     
     Renderbuffer有三种:  color Renderbuffer, depth Renderbuffer, stencil Renderbuffer.
     
     渲染结果是先输出到Framebuffer中,然后通过调用context的presentRenderbuffer,将Framebuffer上的内容提交给之前的CustumView.
     */
    
    //设置当前上下文
    [EAGLContext setCurrentContext:glContext];
    
    
    /*
     target —— 纹理被绑定的目标，它只能取值GL_TEXTURE_1D、GL_TEXTURE_2D、GL_TEXTURE_3D或者GL_TEXTURE_CUBE_MAP；
     texture —— 纹理的名称，并且，该纹理的名称在当前的应用中不能被再次使用。
     glBindTexture可以让你创建或使用一个已命名的纹理，调用glBindTexture方法，将target设置为GL_TEXTURE_1D、GL_TEXTURE_2D、GL_TEXTURE_3D或者GL_TEXTURE_CUBE_MAP，并将texture设置为你想要绑定的新纹理的名称，即可将纹理名绑定至当前活动纹理单元目标。当一个纹理与目标绑定时，该目标之前的绑定关系将自动被打破。纹理的名称是一个无符号的整数。在每个纹理目标中，0被保留用以代表默认纹理。纹理名称与相应的纹理内容位于当前GL rendering上下文的共享对象空间中。
     */
    
    //绑定Y纹理
    glBindTexture(GL_TEXTURE_2D, id_y);
    
    /**
     根据像素数据,加载纹理
     */
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RED_EXT, width, height, 0, GL_RED_EXT, GL_UNSIGNED_BYTE, blackData);
    
    //绑定U纹理
    glBindTexture(GL_TEXTURE_2D, id_u);
    //加载纹理
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RED_EXT, width/2, height/2, 0, GL_RED_EXT, GL_UNSIGNED_BYTE, blackData + width * height);
    
    //绑定V数据
    glBindTexture(GL_TEXTURE_2D, id_v);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RED_EXT, width/2, height/2, 0, GL_RED_EXT, GL_UNSIGNED_BYTE, blackData + width * height * 5 / 4);
    
    //释放malloc分配的内存空间
    free(blackData);
}

/**
 显示YUV数据
 
 @param data YUV数据
 */
-(void)displayYUV420pData:(void *)data width:(NSInteger)width height:(NSInteger)height {
    
    [self setVideoWitdth:(GLuint)width height:(GLuint)height];
    
//    //YUV Data
//    plane[0] = buf;
//    plane[1] = plane[0] + pixel_w*pixel_h;
//    plane[2] = plane[1] + pixel_w*pixel_h/4;
    
    //display
    [self display:data];
}


//display
-(void)display:(void *)data {
    if (fread(buf, 1, pixel_w*pixel_h*3/2, infile) != pixel_w*pixel_h*3/2){
        // Loop
        fseek(infile, 0, SEEK_SET);
        fread(buf, 1, pixel_w*pixel_h*3/2, infile);
    }
    //Clear
    glClearColor(0.0,255,0.0,0.0);
    glClear(GL_COLOR_BUFFER_BIT);
    //Y
    //
    glActiveTexture(GL_TEXTURE0);
    
    glBindTexture(GL_TEXTURE_2D, id_y);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_LUMINANCE_ALPHA, pixel_w, pixel_h, 0, GL_LUMINANCE_ALPHA, GL_UNSIGNED_BYTE, data);
    
    glUniform1i(textureUniformY, 0);
    //U
    glActiveTexture(GL_TEXTURE1);
    glBindTexture(GL_TEXTURE_2D, id_u);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_LUMINANCE_ALPHA, pixel_w/2, pixel_h/2, 0, GL_LUMINANCE_ALPHA, GL_UNSIGNED_BYTE, data + pixel_w*pixel_h);
    glUniform1i(textureUniformU, 1);
    //V
    glActiveTexture(GL_TEXTURE2);
    glBindTexture(GL_TEXTURE_2D, id_v);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_LUMINANCE_ALPHA, pixel_w/2, pixel_h/2, 0, GL_LUMINANCE_ALPHA, GL_UNSIGNED_BYTE, data + pixel_w*pixel_h*5/4);
    glUniform1i(textureUniformV, 2);
    
    // Draw
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
    // Show
    //将该渲染缓冲区对象绑定到管线上
    glBindRenderbuffer(GL_RENDERBUFFER, _renderBuffer);
}

//Init Shader
void InitShaders()
{
    GLint vertCompiled, fragCompiled, linked;
    
    GLint v, f;
    const char *vs,*fs;
    //Shader: step1
    v = glCreateShader(GL_VERTEX_SHADER);
    f = glCreateShader(GL_FRAGMENT_SHADER);
    
    //获取着色器源码
    
    
    //Shader: step2
    glShaderSource(v, 1, &vs,NULL);
    glShaderSource(f, 1, &fs,NULL);
    //Shader: step3
    glCompileShader(v);
    //Debug
    glGetShaderiv(v, GL_COMPILE_STATUS, &vertCompiled);
    glCompileShader(f);
    glGetShaderiv(f, GL_COMPILE_STATUS, &fragCompiled);
    
    //Program: Step1
    p = glCreateProgram();
    //Program: Step2
    glAttachShader(p,v);
    glAttachShader(p,f);
    
    glBindAttribLocation(p, ATTRIB_VERTEX, "vertexIn");
    glBindAttribLocation(p, ATTRIB_TEXTURE, "textureIn");
    //Program: Step3
    glLinkProgram(p);
    //Debug
    glGetProgramiv(p, GL_LINK_STATUS, &linked);
    //Program: Step4
    glUseProgram(p);
    
    
    //Get Uniform Variables Location
    textureUniformY = glGetUniformLocation(p, "tex_y");
    textureUniformU = glGetUniformLocation(p, "tex_u");
    textureUniformV = glGetUniformLocation(p, "tex_v");
    
#if TEXTURE_ROTATE
    static const GLfloat vertexVertices[] = {
        -1.0f, -0.5f,
        0.5f, -1.0f,
        -0.5f,  1.0f,
        1.0f,  0.5f,
    };
#else
    static const GLfloat vertexVertices[] = {
        -1.0f, -1.0f,
        1.0f, -1.0f,
        -1.0f,  1.0f,
        1.0f,  1.0f,
    };
#endif
    
#if TEXTURE_HALF
    static const GLfloat textureVertices[] = {
        0.0f,  1.0f,
        0.5f,  1.0f,
        0.0f,  0.0f,
        0.5f,  0.0f,
    };
#else
    static const GLfloat textureVertices[] = {
        0.0f,  1.0f,
        1.0f,  1.0f,
        0.0f,  0.0f,
        1.0f,  0.0f,
    };
#endif
    //Set Arrays
    glVertexAttribPointer(ATTRIB_VERTEX, 2, GL_FLOAT, 0, 0, vertexVertices);
    //Enable it
    glEnableVertexAttribArray(ATTRIB_VERTEX);
    glVertexAttribPointer(ATTRIB_TEXTURE, 2, GL_FLOAT, 0, 0, textureVertices);
    glEnableVertexAttribArray(ATTRIB_TEXTURE);
    
    
    //Init Texture
    glGenTextures(1, &id_y);
    glBindTexture(GL_TEXTURE_2D, id_y);
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    glGenTextures(1, &id_u);
    glBindTexture(GL_TEXTURE_2D, id_u);
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    glGenTextures(1, &id_v);
    glBindTexture(GL_TEXTURE_2D, id_v);
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
}

@end
