//
//  WztTest9VC.m
//  OpenGLESDemo
//
//  Created by wztMac on 2019/3/9.
//  Copyright © 2019年 wzt. All rights reserved.
//

#import "WztTest9VC.h"
#import <OpenGLES/ES1/gl.h>
#import "esShader.h"

@interface WztTest9VC ()
{
    /// Window width height
    GLint       window_width;
    GLint       window_height;
    
    //program
    GLuint programObject;
}
@property (nonatomic , strong) EAGLContext* mContext;

@end

@implementation WztTest9VC

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    [self setupConfig];
    
    [self openglesInit];
}

- (void)setupConfig {
    //新建OpenGLES 上下文
    self.mContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3]; //2.0，还有1.0和3.0
    GLKView* view = (GLKView *)self.view; //storyboard记得添加
    view.context = self.mContext;
    view.drawableColorFormat = GLKViewDrawableDepthFormat24;  //颜色缓冲区格式
    [EAGLContext setCurrentContext:self.mContext];
}


-(void)openglesInit {
    
    const char vShaderStr[] =
    "#version 300 es                            \n"
    "layout(location = 1) in vec4 a_position;   \n"
    "layout(location = 0) in vec4 a_color;      \n"
    "out vec4 v_color;                          \n"
    "void main()                                \n"
    "{                                          \n"
    "    v_color = a_color;                     \n"
    "    gl_Position = a_position;              \n"
    "}";
    
    
    const char fShaderStr[] =
    "#version 300 es            \n"
    "precision mediump float;   \n"
    "in vec4 v_color;           \n"
    "out vec4 o_fragColor;      \n"
    "void main()                \n"
    "{                          \n"
    "    o_fragColor = v_color; \n"
    "}" ;
    
    
    // Create the program object
    programObject = esLoadProgram ( vShaderStr, fShaderStr );
    
    if ( programObject == 0 ) {
        NSLog(@"Create Program failed.");
        return;
    }
    
    //可以设置背景色
    glClearColor(0.3f, 0.6f, 1.0f, 1.0f);
    //glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
}

-(void)openglesDraw {
    
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    //glClear ( GL_COLOR_BUFFER_BIT );
    
    GLfloat color[4] = { 1.0f, 0.5f, 0.1f, 1.0f };
    // 3 vertices, with (x,y,z) per-vertex
    GLfloat vertexPos[3 * 3] =
    {
        0.0f,  0.5f, 0.0f, // v0
        -1.0f, -0.5f, 0.0f, // v1
        1.0f, -0.5f, 0.0f  // v2
    };
    
    glViewport ( 0, 0, window_width, window_height );
    
    glUseProgram (programObject);
    
    
    glVertexAttrib4fv ( 0, color );
    
    glVertexAttribPointer ( 1, 3, GL_FLOAT, GL_FALSE, 0, vertexPos );
    glEnableVertexAttribArray ( 1 );
    
    
    glDrawArrays ( GL_TRIANGLES, 0, 3 );
    
    glDisableVertexAttribArray ( 0 );
}


/**
 *  渲染场景代码
 */
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    window_width = view.drawableWidth;
    window_height = view.drawableHeight;
    
    //启动着色器
    [self openglesDraw];
}


-(void)dealloc {
    
    glDeleteProgram ( programObject );
}
@end
