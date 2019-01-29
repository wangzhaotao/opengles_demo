//
//  WztTest5VC.m
//  OpenGLESDemo
//
//  Created by ocean on 2019/1/28.
//  Copyright © 2019年 wzt. All rights reserved.
//

#import "WztTest5VC.h"
#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/ES3/glext.h>

@interface WztTest5VC () {
    unsigned int _programID;
    unsigned int VBO, VAO;
    
}
@property (nonatomic, strong) EAGLContext *context;

@end

@implementation WztTest5VC

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    [self glkMain];
}

-(void)dealloc {
    glDeleteVertexArrays(1, &VAO);
    glDeleteBuffers(1, &VBO);
}

#pragma mark UIView
-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    glClearColor(0.2f, 0.3f, 0.3f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    [self use];
    glBindVertexArray(VAO);
    glDrawArrays(GL_TRIANGLES, 0, 3);
}

#pragma mark private methods
-(void)glkMain {
    
    //
    [self setupConfig];
    
    //
    [self createShader:[@"shader.vs" UTF8String] fragShaderSource:[@"shader.fs" UTF8String]];
    
    //
    float vertics[] = {
        //position          //colors
        0.5f, -0.5f, 0.0f,  1.0f, 0.0f, 0.0f,   // bottom right
        -0.5f, -0.5f, 0.0f,  0.0f, 1.0f, 0.0f,  // bottom left
        0.0f,  0.5f, 0.0f,  0.0f, 0.0f, 1.0f    // top
    };
    
    //顶点缓冲对象、顶点数组对象
    //unsigned int VBO, VAO;
    glGenVertexArrays(1, &VAO);
    glGenBuffers(1, &VBO);
    //绑定
    glBindVertexArray(VAO);
    
    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertics), vertics, GL_STATIC_DRAW);
    
    //position attribute
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 6*sizeof(float), (void*)0);
    glEnableVertexAttribArray(0);
    //color attribute
    glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 6*sizeof(float), (void*)(3*sizeof(float)));
    glEnableVertexAttribArray(1);
}

-(void)setupConfig {
    
    _context = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES3];
    if (!_context) {
        NSLog(@"failed to create ES context !");
    }
    
    GLKView *view = (GLKView*)self.view;
    view.context = _context;
    view.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
    [EAGLContext setCurrentContext:_context];
}

-(void)use {
    
    glUseProgram(_programID);
}

-(void)createShader:(const char*)vertexShaderSource fragShaderSource:(const char*)fragShaderSource {
    
    unsigned int vertex, fragment;
    //vertex shader
    vertex = glCreateShader(GL_VERTEX_SHADER);
    glShaderSource(vertex, 1, &vertexShaderSource, NULL);
    glCompileShader(vertex);
    checkoutCompileErrors(vertex, @"VERTEX");
    
    fragment = glCreateShader(GL_FRAGMENT_SHADER);
    glShaderSource(fragment, 1, &fragShaderSource, NULL);
    glCompileShader(fragment);
    checkoutCompileErrors(fragment, @"FRAGMENT");
    
    _programID = glCreateProgram();
    glAttachShader(_programID, vertex);
    glAttachShader(_programID, fragment);
    glLinkProgram(_programID);
    checkoutCompileErrors(_programID, @"PROGRAM");
    
    //delete the shaders as they're linked into our program now and no longer necessary.
    glDeleteShader(vertex);
    glDeleteShader(fragment);
}

void checkoutCompileErrors(unsigned int shader, NSString *type)
{
    int success;
    char infoLog[1024];
    if (![type isEqualToString:@"PROGRAM"]) {
        glGetShaderiv(shader, GL_COMPILE_STATUS, &success);
        if (!success) {
            glGetShaderInfoLog(shader, 1024, NULL, infoLog);
            NSLog(@"Error::Shader_Compilation_Error of type:%@\ninfoLog:%s", type, infoLog);
        }
    }else {
        glGetProgramiv(shader, GL_LINK_STATUS, &success);
        if (!success) {
            glGetShaderInfoLog(shader, 1024, NULL, infoLog);
            NSLog(@"Error::Shader_Linking_Error of type:%@\ninfoLog:%s", type, infoLog);
        }
    }
}


@end
