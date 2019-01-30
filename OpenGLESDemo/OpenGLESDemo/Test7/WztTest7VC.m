//
//  WztTest7VC.m
//  OpenGLESDemo
//
//  Created by ocean on 2019/1/30.
//  Copyright © 2019年 wzt. All rights reserved.
//

#import "WztTest7VC.h"
#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/ES3/glext.h>

@interface WztTest7VC ()
{
    GLint shaderProgram;
    unsigned int VBO, VAO, EBO;
}
@property (nonatomic, strong) EAGLContext *conext;

@end

@implementation WztTest7VC

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    [self openglesConfig];
    
    [self openglesMain];
}

-(void)openglesConfig {
    
    _conext = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES3];
    if (!_conext) {
        NSLog(@"failed to create ES context !");
    }
    
    GLKView *view = (GLKView*)self.view;
    view.context = _conext;
    view.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
    [EAGLContext setCurrentContext:_conext];
}

-(void)openglesMain {
    
    NSString *vertexPath = [[NSBundle mainBundle]pathForResource:@"vertex_shader" ofType:@"vsh"];
    NSString *fragPath = [[NSBundle mainBundle]pathForResource:@"frag_shader" ofType:@"fsh"];
    [self loadShaders:vertexPath frag:fragPath];
    
    //
    float vertices[] = {
        //positions        //texture coords
        0.5f,  0.5f, 0.0f,   1.0f, 1.0f, // top right
        0.5f, -0.5f, 0.0f,   1.0f, 0.0f, // bottom right
        -0.5f, -0.5f, 0.0f,   0.0f, 0.0f, // bottom left
        -0.5f,  0.5f, 0.0f,   0.0f, 1.0f  // top left
    };
    unsigned int indices[] = {
        0,1,3,
        1,2,3
    };
    
    //unsigned int VBO, VAO, EBO;
    glGenVertexArrays(1, &VAO);
    glGenBuffers(1, &VBO);
    glGenBuffers(1, &EBO);
    
    glBindVertexArray(VAO);
    
    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
    //
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 5 * sizeof(float), (void*)0);
    glEnableVertexAttribArray(0);
    
    glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, 5 * sizeof(float), (void*)(3 * sizeof(float)));
    glEnableVertexAttribArray(1);
    
    //纹理
    
}
-(void)setupTexture {
    
    //加载图片
    CGImageRef spriteImage = [UIImage imageNamed:@"for_test.jpg"].CGImage;
    if (!spriteImage) {
        NSLog(@"Failed to load image for_test.jpg");
        exit(1);
    }
    //读取图片的大小
    size_t width = CGImageGetWidth(spriteImage);
    size_t height = CGImageGetHeight(spriteImage);
    GLubyte * spriteData = (GLubyte *) calloc(width * height * 4, sizeof(GLubyte)); //rgba共4个byte
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4,
                                                       CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);
    //在CGContextRef上绘图
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
    
    CGContextRelease(spriteContext);
    
    unsigned int texture1, texture2;
    glGenTextures(1, &texture1);
    glBindTexture(GL_TEXTURE_2D, texture1);
    
    // set the texture wrapping parameters
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
    // set texture filtering parameters
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    
    
}


-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    NSLog(@"");
}






#pragma mark private methods
//编译着色器
- (GLuint)loadShaders:(NSString *)vert frag:(NSString *)frag {
    GLuint verShader, fragShader;
    shaderProgram = glCreateProgram();
    
    //编译
    [self compileShader:&verShader type:GL_VERTEX_SHADER file:vert];
    [self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:frag];
    
    //添加着色器
    glAttachShader(shaderProgram, verShader);
    glAttachShader(shaderProgram, fragShader);
    
    //******************************************
    //链接
    glLinkProgram(shaderProgram);
    //******************************************
    
    //释放不需要的shader
    glDeleteShader(verShader);
    glDeleteShader(fragShader);
    
    return shaderProgram;
}
//
- (void)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file {
    //读取字符串
    NSString* content = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil];
    const GLchar* source = (GLchar *)[content UTF8String];
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
}

@end
