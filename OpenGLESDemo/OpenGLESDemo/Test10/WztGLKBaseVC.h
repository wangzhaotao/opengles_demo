//
//  WztGLKBaseVC.h
//  OpenGLESDemo
//
//  Created by wztMac on 2019/3/10.
//  Copyright © 2019年 wzt. All rights reserved.
//

#import <GLKit/GLKit.h>
#import "esShader.h"

@interface WztGLKBaseVC : GLKViewController
{
    @public
    /// Window width height
    GLint       window_width;
    GLint       window_height;
    
    //program
    GLuint programObject;
}

@property (nonatomic , strong) EAGLContext* mContext;

@end

