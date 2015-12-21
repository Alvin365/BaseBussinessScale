//
//  PayAccountViewController.m
//  BusinessScale
//
//  Created by Alvin on 15/12/19.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import "PayAccountViewController.h"
#import "PayAccountCell.h"
@interface PayAccountViewController ()<UITableViewDataSource, UITableViewDelegate>

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

//- (void)buildNavBarItems
//{
//    WS(weakSelf);
//    [self addNavRightBarBtn:@"icon_add" selectorBlock:^{
//        
//    }];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -UITableViewDataSource&&Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellInden = @"cellInden";
    PayAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:cellInden];
    cell.type = (PayWayType)(indexPath.row%2);
    cell.isAdd = indexPath.row%2;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [PayAccountCell cellHeightForIsAdd:indexPath.row%2];
}

@end
