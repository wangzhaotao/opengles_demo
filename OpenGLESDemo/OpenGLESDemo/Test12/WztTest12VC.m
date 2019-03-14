//
//  WztTest12VC.m
//  OpenGLESDemo
//
//  Created by tyler on 3/14/19.
//  Copyright © 2019 wzt. All rights reserved.
//

#import "WztTest12VC.h"
#import "esTransform.h"
#import "esShapes.h"

@interface WztTest12VC ()
{
    // Uniform locations
    GLint  mvpLoc;
    
    // Vertex daata
    GLfloat  *vertices;
    GLuint   *indices;
    int       numIndices;
    
    // Rotation angle
    GLfloat   angle;
    
    // MVP matrix
    ESMatrix  mvpMatrix;
}

@end

@implementation WztTest12VC

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    
    [self openglesInit];
    
}

#pragma mark init
//初始化配置
-(void)openglesInit {
    
    const char vShaderStr[] =
    "#version 300 es                             \n"
    "uniform mat4 u_mvpMatrix;                   \n"
    "layout(location = 0) in vec4 a_position;    \n"
    "layout(location = 1) in vec4 a_color;       \n"
    "out vec4 v_color;                           \n"
    "void main()                                 \n"
    "{                                           \n"
    "   v_color = a_color;                       \n"
    "   gl_Position = u_mvpMatrix * a_position;  \n"
    "}                                           \n";
    
    const char fShaderStr[] =
    "#version 300 es                                \n"
    "precision mediump float;                       \n"
    "in vec4 v_color;                               \n"
    "layout(location = 0) out vec4 outColor;        \n"
    "void main()                                    \n"
    "{                                              \n"
    "  outColor = v_color;                          \n"
    "}                                              \n";
    
    // Load the shaders and get a linked program object
    programObject = esLoadProgram ( vShaderStr, fShaderStr );
    
    //
    mvpLoc = glGetUniformLocation ( programObject, "u_mvpMatrix" );
    
    //
    numIndices = esGenCube ( 1.0, &vertices,
                            NULL, NULL, &indices );
    
    angle = 45.0f;
    
    glClearColor ( 1.0f, 1.0f, 1.0f, 0.0f );
}


#pragma mark private methods
-(void)drawGL {
    
    // Set the viewport
    glViewport ( 0, 0, window_width, window_height );
    
    // Clear the color buffer
    glClear ( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );
    
    // Use the program object
    glUseProgram ( programObject );
    
    // Load the vertex position
    glVertexAttribPointer ( 0, 3, GL_FLOAT,
                           GL_FALSE, 3 * sizeof ( GLfloat ), vertices );
    
    glEnableVertexAttribArray ( 0 );
    
    // Set the vertex color to red
    glVertexAttrib4f ( 1, 1.0f, 0.0f, 0.0f, 1.0f );
    
    // Load the MVP matrix
    glUniformMatrix4fv ( mvpLoc, 1, GL_FALSE, ( GLfloat * ) &mvpMatrix.m[0][0] );
    
    // Draw the cube
    glDrawElements ( GL_TRIANGLES, numIndices, GL_UNSIGNED_INT, indices );
}
- (void)update:(float)deltaTime
{
    ESMatrix perspective;
    ESMatrix modelview;
    float    aspect;
    
    // Compute a rotation angle based on time to rotate the cube
    angle += ( deltaTime * 40.0f );
    
    if ( angle >= 360.0f )
    {
        angle -= 360.0f;
    }
    
    // Compute the window aspect ratio
    aspect = ( GLfloat ) window_width / ( GLfloat ) window_height;
    
    // Generate a perspective matrix with a 60 degree FOV
    esMatrixLoadIdentity ( &perspective );
    esPerspective ( &perspective, 60.0f, aspect, 1.0f, 20.0f );
    
    // Generate a model view matrix to rotate/translate the cube
    esMatrixLoadIdentity ( &modelview );
    
    // Translate away from the viewer
    esTranslate ( &modelview, 0.0, 0.0, -2.0 );
    
    // Rotate the cube
    esRotate ( &modelview, angle, 1.0, 0.0, 1.0 );
    
    // Compute the final MVP by multiplying the
    // modevleiw and perspective matrices together
    esMatrixMultiply ( &mvpMatrix, &modelview, &perspective );
}

#pragma mark 重写
/*
 * 重写方法
 */
-(void)update {
    [self update:self.timeSinceLastUpdate];
}


/**
 *  渲染场景代码
 */
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    [super glkView:view drawInRect:rect];
    
    //glClear ( GL_COLOR_BUFFER_BIT );
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    [self drawGL];
}






@end
