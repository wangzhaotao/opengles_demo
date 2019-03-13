//
//  WztTest11VC.m
//  OpenGLESDemo
//
//  Created by wztMac on 2019/3/10.
//  Copyright © 2019年 wzt. All rights reserved.
//

#import "WztTest11VC.h"

@interface WztTest11VC ()

@end

@implementation WztTest11VC

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    
    [self openglesInit];
    
}

-(void)openglesInit {
    
    const char vShaderStr[] =
    "#version 300 es                            \n"
    "layout(location = 0) in vec4 a_position;   \n"
    "layout(location = 1) in vec4 a_color;      \n"
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

/**
 *  渲染场景代码
 */
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    [super glkView:view drawInRect:rect];
    
    //glClear ( GL_COLOR_BUFFER_BIT );
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    [self openglesDraw];
}


-(void)openglesDraw {
    
    glViewport ( 0, 0, window_width, window_height );
    glUseProgram (programObject);
    
    
    //指定顶点属性
    
    // 3 vertices, with (x,y,z)(r,g,b,a) per-vertex
    GLfloat vertexPos[3 * 7] =
    {
        0.0f,  0.5f,  0.0f,   1.0f, 0.5f, 0.1f, 1.0f,  // v0
        -0.5f, -0.5f, 0.0f,   0.2f, 1.0f, 0.5f, 1.0f,  // v1
        0.5f,  -0.5f, 0.0f,   1.5f, 0.2f, 1.0f, 1.0f,  // v2
    };
    
    int vertex_pos_size = 3;
    int vertex_normal_size=4;
    int vertex_texcord0_size=0;
    
    int vertex_pos_index=0;
    int vertex_normal_index=1;
    int vertex_texcord0_index=2;
    
    int vertex_pos_offset=0;
    int vertex_normal_offset=3;
    int vertex_texcord0_offset=7;
    
    int vertex_attrib_size=vertex_pos_size+vertex_normal_size+vertex_texcord0_size;
    
    float *p=vertexPos;
    
    glVertexAttribPointer(vertex_pos_index, vertex_pos_size, GL_FLOAT, GL_FALSE, vertex_attrib_size*sizeof(float), p+vertex_pos_offset);
    
    glVertexAttribPointer(vertex_normal_index, vertex_normal_size, GL_FLOAT, GL_FALSE, vertex_attrib_size*sizeof(float), p+vertex_normal_offset);
    
    glVertexAttribPointer(vertex_texcord0_index, vertex_pos_size, GL_FLOAT, GL_FALSE, vertex_attrib_size*sizeof(float), p+vertex_texcord0_offset);
    
    
    glEnableVertexAttribArray ( 0 );
    glEnableVertexAttribArray ( 1 );
    
    
    
    
    
    
    
    //draw
    glDrawArrays ( GL_TRIANGLES, 0, 3 );
    //disable
    glDisableVertexAttribArray ( 0 );
    glDisableVertexAttribArray ( 1 );
}





@end
