//
//  SettingViewController.m
//  BusinessScaleBase
//
//  Created by Alvin on 15/12/15.
//  Copyright © 2015年 chipsea. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingCell.h"
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

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation SettingViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        [_dataArray addObject:@[[[SettingViewControllerModel alloc]initWithLabel:@"我的账号" className:@"MyAccountViewController"],[[SettingViewControllerModel alloc]initWithLabel:@"我的设备" className:@"MyDeviceViewController"],[[SettingViewControllerModel alloc]initWithLabel:@"单位设置" className:@"cannotFindxxx"],[[SettingViewControllerModel alloc]initWithLabel:@"商品设定" className:@"GoodsSettingViewController"],[[SettingViewControllerModel alloc]initWithLabel:@"支付账号设定" className:@"PayAccountViewController"]]];
        [_dataArray addObject:@[[[SettingViewControllerModel alloc]initWithLabel:@"意见反馈" className:@"SuggestFeeBackController"],[[SettingViewControllerModel alloc]initWithLabel:@"隐私和协议" className:@"PrivacyViewController"]]];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.backgroundColor = backGroudColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
        if (!cell.segMent.hidden) {
            cell.segItemChanged = ^(NSInteger index){
                
            };
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *arr = self.dataArray[indexPath.section];
    if (!indexPath.section && indexPath.row==2) return;
    SettingViewControllerModel *model = arr[indexPath.row];
    Class ctlClass = NSClassFromString(model.className);
    BaseViewController *ctl = [[ctlClass alloc]init];
    ctl.title = model.label;
    [self.navigationController pushViewController:ctl animated:YES];
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
