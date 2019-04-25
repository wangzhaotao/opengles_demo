//
//  esShader.h
//  OpenGLESDemo
//
//  Created by wztMac on 2019/3/9.
//  Copyright © 2019年 wzt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES3/gl.h>


@interface esShader : NSObject

GLuint esLoadShader ( GLenum type, const char *shaderSrc );

GLuint esLoadProgram ( const char *vertShaderSrc, const char *fragShaderSrc );

@end

