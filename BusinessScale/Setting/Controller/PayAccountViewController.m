//
//  PayAccountViewController.m
//  BusinessScale
//
//  Created by Alvin on 15/12/19.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import "PayAccountViewController.h"
#import "PayAccountCell.h"
#import "AddPayAccountController.h"
#import "SettingRequestTool.h"
#import "PayAccountTool.h"
@interface PayAccountViewController ()<UITableViewDataSource, UITableViewDelegate,UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, copy) NSString *third_uuid;

@end

@implementation PayAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initFromXib];
//    [self buildNavBarItems];
    [self getAccounts];
}

- (void)initFromXib
{
    self.view.backgroundColor = [UIColor colorWithHexString:@"464646"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"464646"];
    [self.tableView registerNib:[UINib nibWithNibName:@"PayAccountCell" bundle:nil] forCellReuseIdentifier:@"cellInden"];
}

#pragma mark - netRequest
- (void)getAccounts
{
    [self.progressHud show:YES];
    SettingRequestTool *req = [[SettingRequestTool alloc]initWithParam:[SettingRequestTool getPayAccounts:nil]];
    [req setReturnBlock:^(NSURLSessionTask *task, NSURLResponse *response, id responseObject) {
        [self doDatasFromNet:responseObject useFulData:^(NSObject *data) {
            if (data) {
                NSMutableArray *arr = [NSMutableArray array];
                for (NSDictionary *dic in (NSArray *)data) {
                    PayAccountModel *model = [[PayAccountModel alloc]init];
                    [model setValuesForKeysWithDictionary:dic];
                    [arr addObject:model];
                }
                [PayAccountTool savePayAccountList:arr];
                [self.tableView reloadData];
            }
        }];
    }];
}

- (void)deleteAccount:(NSString *)account
{
    [self.progressHud show:YES];
    SettingRequestTool *req = [[SettingRequestTool alloc]initWithParam:[SettingRequestTool deleteAccount:account]];
    [req setReturnBlock:^(NSURLSessionTask *task, NSURLResponse *response, id responseObject) {
        [self doDatasFromNet:responseObject useFulData:^(NSObject *data) {
            if (data) {
                NSMutableArray *arr = [NSMutableArray array];
                for (NSDictionary *dic in [PayAccountTool list]) {
                    PayAccountModel *model = [[PayAccountModel alloc]init];
                    [model setValuesForKeysWithDictionary:dic];
                    if (![model.third_uuid isEqualToString:_third_uuid]) {
                        [arr addObject:model];
                    }
                }
                [PayAccountTool savePayAccountList:arr];
                [self.tableView reloadData];
                [MBProgressHUD showSuccess:@"删除成功"];
            }
        }];
    }];
}


#pragma mark -UITableViewDataSource&&Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WS(weakSelf);
    static NSString *cellInden = @"cellInden";
    PayAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:cellInden];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.type = !indexPath.row?PayWayTypeAlipay:PayWayTypeWechatPay;
    cell.model = !indexPath.row?[PayAccountTool alipayAccount]:[PayAccountTool weixinAccount];
    cell.callBack = ^(BOOL isManager){
        [weakSelf cellEventWithIsManager:isManager indexPath:indexPath];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [PayAccountCell cellHeightForIsManager:!indexPath.row?[PayAccountTool alipayAccount]:[PayAccountTool weixinAccount]];
}
#pragma mark -helpMethod
- (void)cellEventWithIsManager:(BOOL)isManager indexPath:(NSIndexPath *)indexPath
{
    if (isManager) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"确定删除该支付账号" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [actionSheet showInView:self.view];
    }else{
        AddPayAccountController *add = [[AddPayAccountController alloc]init];
        add.payWayType = indexPath.row%2==0?PayWayTypeAlipay:PayWayTypeWechatPay;
        add.payTitle = indexPath.row%2==0?@"支付宝":@"微信支付";
        [self.navigationController pushViewController:add animated:YES];
    }
    _third_uuid = !indexPath.row?[PayAccountTool alipayAccount].third_uuid:[PayAccountTool weixinAccount].third_uuid;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [self deleteAccount:_third_uuid];
    }
}

@end
