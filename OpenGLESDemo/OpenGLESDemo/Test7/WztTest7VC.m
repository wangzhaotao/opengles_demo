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
    unsigned int texture1, texture2;
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

-(void)dealloc {
    
    glDeleteVertexArrays(1, &VAO);
    glDeleteBuffers(1, &VBO);
    glDeleteBuffers(1, &EBO);
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
    [self setupTexture];
    
    //
    glUseProgram(shaderProgram);
}
-(void)setupTexture {
    
    //1.加载图片
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
    
    //2.纹理
    //纹理1
    //unsigned int texture1, texture2;
    glGenTextures(1, &texture1);
    glBindTexture(GL_TEXTURE_2D, texture1);
    // set the texture wrapping parameters
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
    // set texture filtering parameters
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    
    float fw = width, fh = height;
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, fw, fh, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    free(spriteData);
    
    //纹理2
    GLubyte * spriteData2 = (GLubyte *) calloc(width * height * 4, sizeof(GLubyte)); //rgba共4个byte
    CGContextRef spriteContext2 = CGBitmapContextCreate(spriteData2, width, height, 8, width*4,
                                                       CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);
    //在CGContextRef上绘图
    CGContextDrawImage(spriteContext2, CGRectMake(width/2, height/2, width, height), spriteImage);
    CGContextRelease(spriteContext2);
    
    //生成纹理
    glGenTextures(1, &texture2);
    glBindTexture(GL_TEXTURE_2D, texture2);
    // set the texture wrapping parameters
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
    // set texture filtering parameters
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, fw, fh, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData2);
    free(spriteData2);
    
    
}


-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    glClearColor(0.2f, 0.3f, 0.3f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture1);
    glActiveTexture(GL_TEXTURE1);
    glBindTexture(GL_TEXTURE_2D, texture2);
    
    // create transformations
//    glm::mat4 transform = glm::mat4(1.0f); // make sure to initialize matrix to identity matrix first
//    transform = glm::translate(transform, glm::vec3(0.5f, -0.5f, 0.0f));
//    transform = glm::rotate(transform, (float)glfwGetTime(), glm::vec3(0.0f, 0.0f, 1.0f));
//
//    // get matrix's uniform location and set matrix
//    glUseProgram(shaderProgram);
//    unsigned int transformLoc = glGetUniformLocation(ourShader.ID, "transform");
//    glUniformMatrix4fv(transformLoc, 1, GL_FALSE, glm::value_ptr(transform));
//
//    // render container
//    glBindVertexArray(VAO);
//    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, 0);
    
    //设置position值
    GLuint position = glGetAttribLocation(shaderProgram, "position");
    glVertexAttribPointer(position, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, NULL);
    glEnableVertexAttribArray(position);
    
    //设置textCoordinate值
    GLuint textCoor = glGetAttribLocation(shaderProgram, "textCoordinate");
    glVertexAttribPointer(textCoor, 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, (float *)NULL + 3);
    glEnableVertexAttribArray(textCoor);
    
    //获取shader里面的变量，这里记得要在glLinkProgram后面，后面，后面！
    GLuint rotate = glGetUniformLocation(shaderProgram, "rotateMatrix");
    
    static int rrr = 0;
    rrr += 10;
    float radians = rrr * 3.14159f / 180.0f;
    float s = sin(radians);
    float c = cos(radians);
    
    //z轴旋转矩阵
    GLfloat zRotation[16] = { //
        c, -s, 0, 0.2, //
        s, c, 0, 0,//
        0, 0, 1.0, 0,//
        0.0, 0, 0, 1.0//
    };
    
    //设置旋转矩阵
    glUniformMatrix4fv(rotate, 1, GL_FALSE, (GLfloat *)&zRotation[0]);
    // render container
    glBindVertexArray(VAO);
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, 0);
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
