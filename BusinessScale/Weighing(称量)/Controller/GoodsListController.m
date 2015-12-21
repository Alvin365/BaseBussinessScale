//
//  GoodsListController.m
//  BusinessScale
//
//  Created by Alvin on 15/12/18.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import "GoodsListController.h"
#import "GoodListCell.h"
#import "GoodsSettingViewController.h"
@interface GoodsListController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation GoodsListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildNavBarItems];
    [self datas];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)buildNavBarItems
{
    WS(weakSelf);
    self.title = @"商品列表";
//    [self addNavRightBarBtn:@"icon_add" selectorBlock:^{
//        GoodsSettingViewController *goods = [[GoodsSettingViewController alloc]init];
//        [weakSelf.navigationController pushViewController:goods animated:YES];
//    }];
}

- (void)datas
{
    _dataArray = [NSMutableArray array];
    for (int i = 0; i<3; i++) {
        GoodsInfoModel *model = [[GoodsInfoModel alloc]init];
        model.icon = @"支付宝";
        model.name = @"西兰花";
        [_dataArray addObject:model];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource&&Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellInden = @"cellInden";
    GoodListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellInden];
    if (!cell) {
        cell = [[GoodListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellInden];
    }
    if (indexPath.row < _dataArray.count) {
        cell.model = _dataArray[indexPath.row];
        cell.sepT.hidden = indexPath.row;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

#pragma mark -sectionHeader

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    @autoreleasepool {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 50)];
        view.backgroundColor = backGroudColor;
        UILabel *l = [[UILabel alloc]initWithFrame:CGRectMake(15, view.height-25, 200, 20)];
        l.text = @"A";
        [view addSubview:l];
        return view;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

@end
