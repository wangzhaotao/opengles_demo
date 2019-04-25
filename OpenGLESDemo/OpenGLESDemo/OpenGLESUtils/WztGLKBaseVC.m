//
//  WztGLKBaseVC.m
//  OpenGLESDemo
//
//  Created by wztMac on 2019/3/10.
//  Copyright © 2019年 wzt. All rights reserved.
//

#import "WztGLKBaseVC.h"

@interface WztGLKBaseVC ()

@end

@implementation WztGLKBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    [self setupConfig];
    
    
}

-(void)dealloc {
    
    glDeleteProgram ( programObject );
}

- (void)setupConfig {
    //新建OpenGLES 上下文
    self.mContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3]; //2.0，还有1.0和3.0
    GLKView* view = (GLKView *)self.view; //storyboard记得添加
    view.context = self.mContext;
    view.drawableColorFormat = GLKViewDrawableDepthFormat24;  //颜色缓冲区格式
    [EAGLContext setCurrentContext:self.mContext];
}

/**
 *  渲染场景代码
 */
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    window_width = view.drawableWidth;
    window_height = view.drawableHeight;
    
    
}


@end
