//
//  WztTest10VC.m
//  OpenGLESDemo
//
//  Created by wztMac on 2019/3/10.
//  Copyright © 2019年 wzt. All rights reserved.
//

#import "WztTest10VC.h"

@interface WztTest10VC ()

@end

@implementation WztTest10VC

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

-(void)openglesDraw {
    
    glViewport ( 0, 0, window_width, window_height );
    glUseProgram (programObject);
    
//    glVertexAttribPointer ( 0, 3, GL_FLOAT, GL_FALSE, 0, vertexPos );
//    glEnableVertexAttribArray ( 0 );
//    glVertexAttrib4fv ( 1, color );
//
//
//    glDrawArrays ( GL_TRIANGLES, 0, 3 );
//
//    glDisableVertexAttribArray ( 0 );
    
    //指定顶点属性
    GLfloat color[4] = { 1.0f, 0.5f, 0.1f, 1.0f };
    // 3 vertices, with (x,y,z) per-vertex
    GLfloat vertexPos[3 * 3] =
    {
        0.0f,  0.5f, 0.0f, // v0
        -1.0f, -0.5f, 0.0f, // v1
        1.0f, -0.5f, 0.0f  // v2
    };
    //method1
    [self jiegouArray:&vertexPos];
    
    //method2
    [self shuzuJieGou];
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

#pragma mark glVertexAttribPointer指定顶点属性
/*
 * glVertexAttribPointer指定顶点属性
 * 分配和存储顶点属性数据有两种常用方法
 * 1.在一个缓存区中存储所有顶点属性(位置、颜色、纹理)--结构数组
 *   结构表示顶点的所有属性，n每个顶点有一个属性的数组；
 * 2.在单独的缓冲区中保存每个顶点属性--数组结构
 */
//*** 结构数组 ***
-(void)jiegouArray:(GLfloat *)vertexPos {
    
    int vertex_pos_size = 3;
    int vertex_normal_size=4;
    int vertex_texcord0_size=0;
    
    int vertex_pos_index=0;
    int vertex_normal_index=1;
    int vertex_texcord0_index=2;
    
    int vertex_pos_offset=0;
    int vertex_normal_offset=3;
    int vertex_texcord0_offset=3;
    
    int vertex_attrib_size=vertex_pos_size+vertex_normal_size+vertex_texcord0_size;
    
    float *p=vertexPos;//(float*)malloc(3*vertex_attrib_size*sizeof(float));
    
    GLfloat color[4] = { 1.0f, 0.5f, 0.1f, 1.0f,
      1.0f, 0.5f, 0.1f, 1.0f,
        1.0f, 0.5f, 0.1f, 1.0f,
    };
    float *colorP = color;
    
    glVertexAttribPointer(vertex_pos_index, vertex_pos_size, GL_FLOAT, GL_FALSE, vertex_pos_size*sizeof(float), p);
    
    glVertexAttribPointer(vertex_normal_index, vertex_normal_size, GL_FLOAT, GL_FALSE, vertex_normal_size*sizeof(float), colorP);
    
    glVertexAttribPointer(vertex_texcord0_index, vertex_texcord0_size, GL_FLOAT, GL_FALSE, vertex_texcord0_size*sizeof(float), p+vertex_texcord0_offset);
    
    glEnableVertexAttribArray ( 0 );
    glEnableVertexAttribArray ( 1 );
    //glVertexAttrib4fv ( 1, color );
    
    glDrawArrays ( GL_TRIANGLES, 0, 3 );
    
    glDisableVertexAttribArray ( 0 );
    glDisableVertexAttribArray ( 1 );
}
//*** 数组结构 ***
-(void)shuzuJieGou {
    
    GLfloat color[4] = { 1.0f, 0.5f, 0.1f, 1.0f };
    // 3 vertices, with (x,y,z) per-vertex
    GLfloat vertexPos[3 * 3] =
    {
        0.0f,  0.5f, 0.0f, // v0
        -1.0f, -0.5f, 0.0f, // v1
        1.0f, -0.5f, 0.0f  // v2
    };
    
    int vertex_pos_size = 3;
    
    int vertex_pos_index=0;
    int vertex_normal_index=1;
    
    int vertex_pos_offset=0;
    
    
    float *p=vertexPos;//(float*)malloc(3*vertex_attrib_size*sizeof(float));
    
    glVertexAttribPointer(vertex_pos_index, vertex_pos_size, GL_FLOAT, GL_FALSE, vertex_pos_size*sizeof(float), p);
    
    glEnableVertexAttribArray ( vertex_pos_index );
    glVertexAttrib4fv ( vertex_normal_index, color );
    
    glDrawArrays ( GL_TRIANGLES, 0, 3 );
    
    glDisableVertexAttribArray ( 0 );
}


@end
