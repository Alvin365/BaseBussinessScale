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
@interface PayAccountViewController ()<UITableViewDataSource, UITableViewDelegate,UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PayAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initFromXib];
//    [self buildNavBarItems];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -UITableViewDataSource&&Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WS(weakSelf);
    static NSString *cellInden = @"cellInden";
    PayAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:cellInden];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.type = (PayWayType)(indexPath.row%2);
    cell.isManager = indexPath.row%2;
    cell.callBack = ^(BOOL isManager){
        [weakSelf cellEventWithIsManager:isManager indexPath:indexPath];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [PayAccountCell cellHeightForIsManager:indexPath.row%2];
}
#pragma mark -helpMethod
- (void)cellEventWithIsManager:(BOOL)isManager indexPath:(NSIndexPath *)indexPath
{
    if (isManager) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"确定删除该支付账号" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [actionSheet showInView:self.view];
    }else{
        AddPayAccountController *add = [[AddPayAccountController alloc]init];
        add.payTitle = indexPath.row%2==0?@"支付宝":@"微信支付";
        [self.navigationController pushViewController:add animated:YES];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        
    }
}

@end
