//
//  SettingViewController.m
//  BusinessScaleBase
//
//  Created by Alvin on 15/12/15.
//  Copyright © 2015年 chipsea. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingCell.h"
#import "ALLogonViewController.h"
#import "ALNavigationController.h"
#import "LogonController.h"
@implementation SettingViewControllerModel

- (instancetype)initWithLabel:(NSString *)label className:(NSString *)className
{
    if (self = [super init]) {
        _label = label;
        _className = className;
    }
    return self;
}

@end

@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIButton *exitLoginBtn;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation SettingViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self datas];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildView];
}

- (void)buildView
{
    _tableView.backgroundColor = backGroudColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 95)];
    view.backgroundColor = backGroudColor;
    _exitLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_exitLoginBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    _exitLoginBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_exitLoginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _exitLoginBtn.frame = CGRectMake(20, 20, screenWidth-40, 55);
    [_exitLoginBtn addTarget:self action:@selector(exist) forControlEvents:UIControlEventTouchUpInside];
    _exitLoginBtn.backgroundColor = ALRedColor;
    [view addSubview:_exitLoginBtn];
    _exitLoginBtn.layer.cornerRadius = 5;
    _exitLoginBtn.layer.masksToBounds = YES;
    self.tableView.tableFooterView = view;
}

- (void)datas
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    [_dataArray removeAllObjects];
    [_dataArray addObject:@[[[SettingViewControllerModel alloc]initWithLabel:@"我的账号" className:@"MyAccountViewController"],[[SettingViewControllerModel alloc]initWithLabel:@"我的设备" className:@"MyDeviceController"],[[SettingViewControllerModel alloc]initWithLabel:@"单位设置" className:@"cannotFindxxx"],[[SettingViewControllerModel alloc]initWithLabel:@"商品设定" className:@"GoodsSettingViewController"],[[SettingViewControllerModel alloc]initWithLabel:@"支付账号设定" className:@"PayAccountViewController"],[[SettingViewControllerModel alloc]initWithLabel:@"PIN码设定" className:@"SetPinningController"]]];
    [_dataArray addObject:@[[[SettingViewControllerModel alloc]initWithLabel:@"意见反馈" className:@"SuggesstViewController"],[[SettingViewControllerModel alloc]initWithLabel:@"隐私和协议" className:@"LienceController"]]];
}

- (void)exist
{
    [self.progressHud show:YES];
    [LocalDataTool removeDocumAtPath:@"account.data"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.progressHud hide:YES];
        LogonController *ctl = [[LogonController alloc]init];
        ALNavigationController *nav = [[ALNavigationController alloc]initWithRootViewController:ctl];
        [UIApplication sharedApplication].delegate.window.rootViewController = nav;
    });
}

#pragma mark - UITableViewDataSource&&UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = self.dataArray[section];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellInden = @"cellInden";
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellInden];
    if (!cell) {
        cell = [[SettingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellInden];
    }
    NSArray *arr = self.dataArray[indexPath.section];
    if (indexPath.row < arr.count) {
        cell.textLabel.text = [arr[indexPath.row] label];
        cell.sepT.hidden = indexPath.row;
        cell.segMent.hidden = indexPath.row!=2;
        if (indexPath.row==2) {
            [cell.rightArrow removeFromSuperview];
        }else{
            [cell addSubview:cell.rightArrow];
        }
        if (!cell.segMent.hidden) {
            cell.segItemChanged = ^(NSInteger index){
                
            };
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70*ALScreenScalWidth;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *arr = self.dataArray[indexPath.section];
        if (!indexPath.section && indexPath.row==2) return;
        SettingViewControllerModel *model = arr[indexPath.row];
        Class ctlClass = NSClassFromString(model.className);
        BaseViewController *ctl = [[ctlClass alloc]init];
        ctl.title = model.label;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController:ctl animated:YES];
        });
    });
}

#pragma mark - sectionHeader
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    @autoreleasepool {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 20)];
        view.backgroundColor = backGroudColor;
        return view;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (!section) {
        return 0;
    }
    return 20;
}

@end
