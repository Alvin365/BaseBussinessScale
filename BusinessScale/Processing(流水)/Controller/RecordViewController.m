//
//  RecordViewController.m
//  BusinessScale
//
//  Created by Alvin on 15/12/17.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import "RecordViewController.h"
#import "RecordHeader.h"
#import "RecordCell.h"
#import "RecordSectionView.h"
@interface RecordViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) RecordHeader *header;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation RecordViewController

- (RecordHeader *)header
{
    if (!_header) {
        _header = [RecordHeader loadXibView];
        _header.callBack = ^(RecordHeaderTag tag){
            if (tag == RecordHeaderTag_Left) {
                
            }else{
                
            }
        };
    }
    return _header;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initFromXib];
    [self datas];
}

- (void)initFromXib
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = self.header;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.title = @"收入记录";
}

- (void)datas
{
    _dataArray = [NSMutableArray array];
    for (int i = 0; i<5; i++) {
        NSMutableArray *arr = [NSMutableArray array];
        for (int j = 0; j<10; j++) {
            GoodsInfoModel *model = [[GoodsInfoModel alloc]init];
            if (j%3==0) {
//                model.icon = @"支付宝";
                model.title = @"张**";
                model.price = @"80元";
            }else if (j%3==1){
//                model.icon = @"RMB";
                model.title = @"现金";
                model.price = @"100元";
            }else{
//                model.icon = @"微信支付";
                model.title = @"钟**";
                model.price = @"160元";
            }
            [arr addObject:model];
        }
        [_dataArray addObject:arr];
    }
}

#pragma mark - UITableViewDataSource&&UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellInden = @"cellInden";
    RecordCell *cell = [tableView dequeueReusableCellWithIdentifier:cellInden];
    if (!cell) {
        cell = [[RecordCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellInden];
    }
    if (indexPath.section < _dataArray.count) {
        NSArray *arr = _dataArray[indexPath.section];
        if (indexPath.row < arr.count) {
            cell.model = arr[indexPath.row];
            if (!indexPath.row) [cell showTopSeparaLine];
        }
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = _dataArray[section];
    return arr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark -section
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    @autoreleasepool {
        RecordSectionView *view = [RecordSectionView loadXibView];
        return view;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
