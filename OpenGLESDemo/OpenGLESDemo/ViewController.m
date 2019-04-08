//
//  ViewController.m
//  OpenGLESDemo
//
//  Created by ocean on 2019/1/17.
//  Copyright © 2019年 wzt. All rights reserved.
//

#import "ViewController.h"

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
    
    NSDictionary *dic = @{@"name":@"test1", @"action":@"clickCellAction:", @"vc":@"WztTest1VC"};
    [_dataArray addObject:dic];
    
    dic = @{@"name":@"test2", @"action":@"clickCellAction:", @"vc":@"WztTest2VC"};
    [_dataArray addObject:dic];
    
    dic = @{@"name":@"test3", @"action":@"clickCellAction:", @"vc":@"WztTest3VC"};
    [_dataArray addObject:dic];
    
    dic = @{@"name":@"test4", @"action":@"clickCellAction:", @"vc":@"WztTest4VC"};
    [_dataArray addObject:dic];
    
    dic = @{@"name":@"test5", @"action":@"clickCellAction:", @"vc":@"WztTest5VC"};
    [_dataArray addObject:dic];
    
    dic = @{@"name":@"test6", @"action":@"clickCellAction:", @"vc":@"WztTest6VC"};
    [_dataArray addObject:dic];
    
    dic = @{@"name":@"test7", @"action":@"clickCellAction:", @"vc":@"WztTest7VC"};
    [_dataArray addObject:dic];
    
    dic = @{@"name":@"test8", @"action":@"clickCellAction:", @"vc":@"WztTest8VC"};
    [_dataArray addObject:dic];

    //
    dic = @{@"name":@"test9", @"action":@"clickCellAction:", @"vc":@"WztTest9VC"};
    [_dataArray addObject:dic];
    
    dic = @{@"name":@"test10", @"action":@"clickCellAction:", @"vc":@"WztTest10VC"};
    [_dataArray addObject:dic];
    
    dic = @{@"name":@"test11", @"action":@"clickCellAction:", @"vc":@"WztTest11VC"};
    [_dataArray addObject:dic];
    
    dic = @{@"name":@"test12", @"action":@"clickCellAction:", @"vc":@"WztTest12VC"};
    [_dataArray addObject:dic];
    
    //
    dic = @{@"name":@"test13", @"action":@"clickCellAction:", @"vc":@"WztTest13VC"};
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
