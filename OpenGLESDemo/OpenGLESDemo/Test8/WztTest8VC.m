//
//  WztTest8VC.m
//  OpenGLESDemo
//
//  Created by ocean on 2019/1/31.
//  Copyright © 2019年 wzt. All rights reserved.
//

#import "WztTest8VC.h"
#import "WztTest8View.h"

@interface WztTest8VC ()
@property (nonatomic, strong) WztTest8View *openglesView;

@end

@implementation WztTest8VC

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.openglesView = [[WztTest8View alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.openglesView];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.openglesView.frame = self.view.bounds;
}






@end
