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
#import "WztTest5VC.h"
#import "WztTest6VC.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUI];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.tableView.frame = self.view.bounds;
}

#pragma mark UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    
    NSDictionary *dic = self.dataArray[indexPath.row];
    NSString *name = dic[@"name"];
    cell.textLabel.text = name;
    
    return cell;
}

#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dic = self.dataArray[indexPath.row];
    Class cls = NSClassFromString(dic[@"vc"]);
    UIViewController *vc = (UIViewController*)[cls new];
    
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50.0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc]init];
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc]init];
}

#pragma mark private methods
-(void)initUI {
    
    [self createData];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    [self.tableView reloadData];
}
-(void)createData {
    
    _dataArray = [NSMutableArray array];
    
    NSDictionary *dic = @{@"name":@"test1", @"action":@"clickCellAction:", @"vc":NSStringFromClass([WztTest1VC class])};
    [_dataArray addObject:dic];
    
    dic = @{@"name":@"test2", @"action":@"clickCellAction:", @"vc":NSStringFromClass([WztTest2VC class])};
    [_dataArray addObject:dic];
    
    dic = @{@"name":@"test3", @"action":@"clickCellAction:", @"vc":NSStringFromClass([WztTest3VC class])};
    [_dataArray addObject:dic];
    
    dic = @{@"name":@"test4", @"action":@"clickCellAction:", @"vc":NSStringFromClass([WztTest4VC class])};
    [_dataArray addObject:dic];
    
    dic = @{@"name":@"test5", @"action":@"clickCellAction:", @"vc":NSStringFromClass([WztTest5VC class])};
    [_dataArray addObject:dic];
    
    dic = @{@"name":@"test6", @"action":@"clickCellAction:", @"vc":NSStringFromClass([WztTest6VC class])};
    [_dataArray addObject:dic];
}

#pragma mark set/get
-(UITableView*)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}



@end
