//
//  ViewController.m
//  OpenGLESDemo
//
//  Created by ocean on 2019/1/17.
//  Copyright © 2019年 wzt. All rights reserved.
//

#import "ViewController.h"
#import "WztTest1VC.h"
#import "WztTest2VC.h"
#import "WztTest3VC.h"
#import "WztTest4VC.h"

@interface ViewController ()
- (IBAction)btn1Action:(UIButton *)sender;
- (IBAction)btn2Action:(UIButton *)sender;
- (IBAction)btn3Action:(UIButton *)sender;
- (IBAction)btn4Action:(UIButton *)sender;


@end

@implementation ViewController
{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (IBAction)btn1Action:(UIButton *)sender {
    
    WztTest1VC *vc = [WztTest1VC new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btn2Action:(UIButton *)sender {
    
    WztTest2VC *vc = [WztTest2VC new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btn3Action:(UIButton *)sender {
    
    WztTest3VC *vc = [WztTest3VC new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btn4Action:(UIButton *)sender {
    
    WztTest4VC *vc = [WztTest4VC new];
    [self.navigationController pushViewController:vc animated:YES];
}



@end
