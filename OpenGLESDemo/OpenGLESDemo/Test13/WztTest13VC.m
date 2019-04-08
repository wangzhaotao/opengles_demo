//
//  WztTest13VC.m
//  OpenGLESDemo
//
//  Created by tyler on 4/8/19.
//  Copyright © 2019 wzt. All rights reserved.
//

#import "WztTest13VC.h"

@interface WztTest13VC ()

@end

@implementation WztTest13VC

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    [self openglesInit];
    
    
}


#pragma mark init
//初始化配置
-(void)openglesInit {
    
    const char vShaderStr[] =
    "#version 300 es                                \n"
    "layout(location = 0) in vec3 aPos;             \n"
    "layout(location = 1) in vec2 aTexCoord;        \n"
    "out vec2 TexCoord;                             \n"
    "uniform mat4 transform;                        \n"
    "void main()                                    \n"
    "{                                              \n"
    "   gl_Position = transform * vec4(aPos, 1.0);  \n"
    "   TexCoord = vec2(aTexCoord.x, aTexCoord.y);  \n"
    "}                                              \n";
    
    const char fShaderStr[] =
    "#version 300 es                                \n"
    "out vec4 FragColor;                            \n"
    "in vec2 TexCoord;                              \n"
    "uniform sampleer2D texture1;                   \n"
    "uniform sampleer2D texture2;                   \n"
    "void main()                                    \n"
    "{                                              \n"
    "    FragColor = mix(texture(texture1, TexCoord), texture(texture2, TexCoord), 0.2); \n"
    "}                                             \n";
    
    // Load the shaders and get a linked program object
    programObject = esLoadProgram ( vShaderStr, fShaderStr );
    
    
}




#pragma mark 重写
/*
 * 重写方法
 */
-(void)update {
    //[self update:self.timeSinceLastUpdate];
}


/**
 *  渲染场景代码
 */
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    [super glkView:view drawInRect:rect];
    
    //glClear ( GL_COLOR_BUFFER_BIT );
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    //[self drawGL];
}


@end
