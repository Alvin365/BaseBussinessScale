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
#import "WXApiRequestHandler.h"
#import "Constant.h"
#import "WXApiManager.h"
#import "LoginHttpTool.h"
#import "PayAttentionWeixinController.h"
#import "WeixinAccountCell.h"
@interface PayAccountViewController ()<UITableViewDataSource, UITableViewDelegate,UIActionSheetDelegate,WXApiManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary *dataDic;

@property (nonatomic, copy) NSString *third_uuid;

@end

@implementation PayAccountViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getWechatInfo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initFromXib];
    [self buildNavBarItems];
    [self datas];
    [WXApiManager sharedManager].delegate = self;
}

- (void)initFromXib
{
    self.view.backgroundColor = [UIColor colorWithHexString:@"464646"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"464646"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WeixinAccountCell" bundle:nil] forCellReuseIdentifier:@"cellInden"];
}

- (void)buildNavBarItems
{
    WS(weakSelf);
    [self addNavRightBarBtn:@"管理" selectorBlock:^{
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"确定删除该支付账号" delegate:weakSelf cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [actionSheet showInView:weakSelf.view];
    }];
}

- (void)datas
{
    _dataDic = [NSMutableDictionary dictionary];
//    [self getAccounts];
}

#pragma mark - netRequest
- (void)getAccounts
{
    /** 没网络时显示本地数据*/
    if ([Reachability shareReachAbilty].currentReachabilityStatus == NotReachable) {
        [[PayAccountModel getUsingLKDBHelper]search:[PayAccountModel class] where:nil orderBy:nil offset:0 count:100 callback:^(NSMutableArray *array) {
            for (PayAccountModel *model in array) {
               [_dataDic setObject:model forKey:model.third_type];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }];
        return;
    }
    /** 有网络同步云端账号*/
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

- (void)getVeryCodeCompleteBlock:(void(^)())completeBlock
{
    [self.progressHud show:YES];
    LoginHttpTool *req = [[LoginHttpTool alloc]initWithParam:[LoginHttpTool getVeryCodeWithParams:@{@"uid":[AccountTool account].phone,@"flag":@"3"}]];
    [req setReturnBlock:^(NSURLSessionTask *task,NSURLResponse *response, id responseObject) {
        [self doDatasFromNet:responseObject useFulData:^(NSObject *data) {
            if (data) {
                [MBProgressHUD showMessage:@"验证码已成功发送到您手机"];
                if (completeBlock) {
                    completeBlock();
                }
            }
        }];
    }];
}

- (void)boundWechatAccountWithParams:(NSDictionary *)params completedBlock:(void(^)())block
{
    [self.progressHud show:YES];
    SettingRequestTool *req = [[SettingRequestTool alloc]initWithParam:[SettingRequestTool boundWechatAccountWithParams:params]];
    [req setReturnBlock:^(NSURLSessionTask *task, NSURLResponse *response, id responseObject) {
        [self doDatasFromNet:responseObject useFulData:^(NSObject *data) {
            if (data) {
                if (block) {
                    block();
                }
            }
        }];
    }];
}

- (void)getWechatInfo
{
    [self.progressHud show:YES];
    SettingRequestTool *req = [[SettingRequestTool alloc]initWithParam:[SettingRequestTool getWechatAccountInfo]];
    [req setReturnBlock:^(NSURLSessionTask *task, NSURLResponse *response, id responseObject) {
        [self doDatasFromNet:responseObject useFulData:^(NSObject *data) {
            if (data) {
                NSDictionary *dic = (NSDictionary *)data;
                if (dic[@"code"]) {
                    self.navigationItem.rightBarButtonItem = nil;
                    return ;
                }else{
                    if (!self.navigationItem.rightBarButtonItem) {
                        [self buildNavBarItems];
                    }
                }
                PayAccountModel *model = [[PayAccountModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                model.third_type = @"weixin";
                [[PayAccountModel getUsingLKDBHelper]insertToDB:model];
                [_dataDic setObject:model forKey:@"weixin"];
                [self.tableView reloadData];
            }
        }];
    }];
}

- (void)deleteWechatInfo
{
    [self.progressHud show:YES];
    SettingRequestTool *req = [[SettingRequestTool alloc]initWithParam:[SettingRequestTool deleteWechatAccountInfo]];
    [req setReturnBlock:^(NSURLSessionTask *task, NSURLResponse *response, id responseObject) {
        [self doDatasFromNet:responseObject useFulData:^(NSObject *data) {
            if (data) {
                [_dataDic removeObjectForKey:@"weixin"];
                [self.tableView reloadData];
                [MBProgressHUD showSuccess:@"删除成功"];
                self.navigationItem.rightBarButtonItem = nil;
            }
        }];
    }];
}

#pragma mark -UITableViewDataSource&&Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WS(weakSelf);
    static NSString *cellInden = @"cellInden";
    WeixinAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:cellInden];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = _dataDic[@"weixin"];
    cell.model = indexPath.row==0?_dataDic[@"weixin"]:_dataDic[@"alipay"];
    cell.callBack = ^(WeixinCellButtonTag tag){
        [weakSelf cellEventWithWeixinCellButtonTag:tag indexPath:indexPath];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _dataDic[@"weixin"]?210:85;
}
#pragma mark -helpMethod
- (void)cellEventWithWeixinCellButtonTag:(WeixinCellButtonTag)tag indexPath:(NSIndexPath *)indexPath
{
    if (tag == WeixinCellButtonTagOperation) {
        PayAttentionWeixinController *p = [[PayAttentionWeixinController alloc]init];
        [self.navigationController pushViewController:p animated:YES];
    }else{
        [WXApiRequestHandler sendAuthRequestScope: kAuthScope
                                            State:kAuthState
                                           OpenID:nil
                                 InViewController:self];
    }
    PayAccountModel *model = indexPath.row?_dataDic[@"weixin"]:_dataDic[@"alipay"];
    _third_uuid = model.third_uuid;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [self deleteWechatInfo];
    }
}

#pragma mark - WXApiManagerDelegate
- (void)managerDidRecvAuthResponse:(SendAuthResp *)response {
    // 授权登录结果
    if (response.errCode == WXErrCodeUserCancel) {
        [MBProgressHUD showMessage:@"用户已取消微信登录"];
        return;
    }
    
    [self.progressHud show:YES];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",kAppID,kAppSecret,response.code]]] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        ALLog(@"weixin respose = %@ \n dataDic = %@",response,dataDic);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self boundWechatAccountWithParams:dataDic completedBlock:^{
                [self getWechatInfo];
            }];
        });
    }];
    [task resume];
}

@end
