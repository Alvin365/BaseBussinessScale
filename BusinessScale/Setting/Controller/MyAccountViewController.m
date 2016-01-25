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
#import "CsChangePwdView.h"
#import "LoginHttpTool.h"
@interface MyAccountViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tabView;
@property (nonatomic, strong) CsChangePwdView *csPopView;

@end

@implementation MyAccountViewController

- (CsChangePwdView *)csPopView
{
    if (!_csPopView) {
        _csPopView = [CsChangePwdView showChangePwdView];
    }
    return _csPopView;
}

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

- (void)resetPassWord:(NSDictionary *)param
{
    [self.progressHud show:YES];
    LoginHttpTool *req = [[LoginHttpTool alloc]initWithParam:[LoginHttpTool updatePassWordWithParams:param]];
    [req setReturnBlock:^(NSURLSessionTask *task,NSURLResponse *response, id responseObject) {
        [self doDatasFromNet:responseObject useFulData:^(NSObject *data) {
            if (data) {
                [self.csPopView hide];
                [MBProgressHUD showSuccess:@"重置密码成功"];
            }
        }];
    }];
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
            WS(weakSelf);
            [self.csPopView show];
            self.csPopView.callBack = ^(NSDictionary *params){
                [weakSelf resetPassWord:params];
            };
        }
    }
}

@end
