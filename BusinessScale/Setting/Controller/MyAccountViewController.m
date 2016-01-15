//
//  MyAccountViewController.m
//  BusinessScale
//
//  Created by Alvin on 15/12/19.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import "MyAccountViewController.h"
#import "MyAccountCell.h"
#import "LogonController.h"
#import "ALNavigationController.h"
#import "ALResetPwdController.h"
@interface MyAccountViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tabView;

@end

@implementation MyAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildView];
}

- (void)buildView
{
    _tabView = [[UITableView alloc]initWithFrame:self.view.bounds];
    _tabView.delegate = self;
    _tabView.dataSource = self;
    _tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tabView];
}
#pragma mark - UITableViewDataSource&&UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellInden = @"cellInden";
    MyAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:cellInden];
    if (!cell) {
        cell = [[MyAccountCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellInden];
        cell.textLabel.textColor = ALTextColor;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    cell.sepT.hidden = indexPath.row==1;
    if ([AccountTool account].token.length) {
        if (!indexPath.row) {
            cell.textLabel.text = [NSString stringWithFormat:@"账号：%@",[AccountTool account].phone];
        }else{
            cell.textLabel.text = @"重置密码";
        }
        cell.rightArrow.hidden = !indexPath.row;
    }else{
        cell.textLabel.text = @"用户未登录";
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70*ALScreenScalWidth;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WS(weakSelf);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (![AccountTool account].token.length) {
        LogonController *log = [[LogonController alloc]init];
        ALNavigationController *nav = [[ALNavigationController alloc]initWithRootViewController:log];
        __weak typeof (ALNavigationController *)weakNav = nav;
        nav.callBack = ^{
            [weakNav dismissViewControllerAnimated:YES completion:nil];
            [weakSelf.tabView reloadData];
        };
        [self presentViewController:nav animated:YES completion:nil];
    }else{
        if (indexPath.row) {
            ALResetPwdController *reset = [[ALResetPwdController alloc]initWithNibName:@"ResetPwdController" bundle:nil];
            reset.tele = [AccountTool account].phone;
            
            ALNavigationController *nav = [[ALNavigationController alloc]initWithRootViewController:reset];
            __weak typeof (ALNavigationController *)weakNav = nav;
            nav.callBack = ^{
                [weakNav dismissViewControllerAnimated:YES completion:nil];
                [weakSelf.tabView reloadData];
            };
            [self presentViewController:nav animated:YES completion:nil];
        }
    }
}

@end
