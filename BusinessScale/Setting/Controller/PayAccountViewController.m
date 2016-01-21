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
#import "PayAccountModel.h"
@interface PayAccountViewController ()<UITableViewDataSource, UITableViewDelegate,UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary *dataDic;

@property (nonatomic, copy) NSString *third_uuid;


@end

@implementation PayAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initFromXib];
    [self datas];
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

- (void)datas
{
    _dataDic = [NSMutableDictionary dictionary];
    [self getAccounts];
}

#pragma mark - netRequest
- (void)getAccounts
{
    [self.progressHud show:YES];
    SettingRequestTool *req = [[SettingRequestTool alloc]initWithParam:[SettingRequestTool getPayAccounts:nil]];
    [req setReturnBlock:^(NSURLSessionTask *task, NSURLResponse *response, id responseObject) {
        [self doDatasFromNet:responseObject useFulData:^(NSObject *data) {
            if (data) {
                for (NSDictionary *dic in (NSArray *)data) {
                    PayAccountModel *model = [[PayAccountModel alloc]init];
                    [model setValuesForKeysWithDictionary:dic];
                    [[PayAccountModel getUsingLKDBHelper]insertToDB:model];
                    [_dataDic setObject:model forKey:model.third_type];
                }
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
                NSString *uid = [_dataDic[@"alipay"] third_uuid];
                if ([uid isEqualToString:_third_uuid]) {
                    [_dataDic removeObjectForKey:@"alipay"];
                }else{
                    [_dataDic removeObjectForKey:@"weixin"];
                }
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
    if (indexPath.row == 0) {
        cell.model = _dataDic[@"alipay"];
    }else if (indexPath.row == 1){
        cell.model = _dataDic[@"weixin"];
    }
    cell.model = indexPath.row?_dataDic[@"weixin"]:_dataDic[@"alipay"];
    cell.callBack = ^(BOOL isManager){
        [weakSelf cellEventWithIsManager:isManager indexPath:indexPath];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [PayAccountCell cellHeightForIsManager:indexPath.row?_dataDic[@"weixin"]:_dataDic[@"alipay"]];
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
    PayAccountModel *model = indexPath.row?_dataDic[@"weixin"]:_dataDic[@"alipay"];
    _third_uuid = model.third_uuid;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [self deleteAccount:_third_uuid];
    }
}

@end
