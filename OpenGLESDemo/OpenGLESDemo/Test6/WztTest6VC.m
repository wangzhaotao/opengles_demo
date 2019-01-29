//
//  WztTest6VC.m
//  OpenGLESDemo
//
//  Created by ocean on 2019/1/29.
//  Copyright © 2019年 wzt. All rights reserved.
//

#import "WztTest6VC.h"
#import "LearnView.h"

@interface WztTest6VC ()
@property (nonatomic, strong) LearnView *openglesView;

@end

@implementation WztTest6VC

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    self.openglesView = (LearnView*)self.view;
    
}





@end
