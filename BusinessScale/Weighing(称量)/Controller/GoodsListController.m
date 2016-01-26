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
#import "WeightBussiness.h"
#import "ContactsIndexsView.h"
#import "GoodsAddView.h"
#import "GoodsListHttpTool.h"
#import <Commercial-Bluetooth/CsBtUtil.h>
@interface GoodsListController ()<UITableViewDataSource,UITableViewDelegate>
{
    CGFloat addGoodsViewBottom;
    CsBtUtil *_btUtil;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) ContactsIndexsView *titlesIndexs;
@property (nonatomic, strong) GoodsAddView *addGoodsView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation GoodsListController

- (GoodsAddView *)addGoodsView
{
    if (!_addGoodsView) {
        WS(weakSelf);
        _addGoodsView = [GoodsAddView loadXibView];
        _addGoodsView.frame = [UIScreen mainScreen].bounds;
        _addGoodsView.callBack = ^(GoodsTempList *model){
            [weakSelf insertNewGoodsWithModel:model];
        };
    }
    return _addGoodsView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildNavBarItems];
    [self datas];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    _btUtil = [CsBtUtil getInstance];
}

- (void)buildNavBarItems
{
    WS(weakSelf);
    self.title = @"商品列表";
    _titlesIndexs = [[ContactsIndexsView alloc]initWithFrame:CGRectMake(screenWidth-30*ALScreenScalWidth,0, 30*ALScreenScalWidth, (screenHeight-64))];
    _titlesIndexs.callBack = ^(NSString *name){
        if (weakSelf.tableView.contentSize.height > weakSelf.tableView.frame.size.height)
        {
            [weakSelf tableViewScroToSectionWithTitle:name];
        }
    };
    [self.view addSubview:_titlesIndexs];
}

- (void)datas
{
    _dataArray = [NSMutableArray array];
    WeightBussiness *bussiness = [[WeightBussiness alloc]init];
    [bussiness getGoodsListCompletedBlock:^(NSArray *array) {
        [_dataArray addObjectsFromArray:array];
        [self.tableView reloadData];
        NSArray *datas = [[UILocalizedIndexedCollation currentCollation] sectionTitles];
        NSMutableArray *existTitles = [NSMutableArray array];
        for (int i = 0; i < [datas count]; i++) {
            if ([[self.dataArray objectAtIndex:i] count] > 0) {
                [existTitles addObject:[datas objectAtIndex:i]];
            }
        }
        _titlesIndexs.dataSource = existTitles;
    }];
    
    addGoodsViewBottom = 107*ALScreenScalHeight;
}
/**
 * 点击右边条 滚动至相关section
 */
- (void)tableViewScroToSectionWithTitle:(NSString *)title
{
    NSInteger section = 0;
    NSString *str = nil;
    for (NSArray *arr in self.dataArray) {
        if (arr.count) {
            str = [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:(section)];
            if ([title isEqualToString:str]) {
                break;
            }
        }
        section ++;
    }
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

#pragma mark -keyBoardNotice
- (void)keyboardWillShow:(NSNotification *)noti
{
    // 获取键盘的高度
    CGRect kbEndFrm = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat kbHeight =  kbEndFrm.size.height;
    CGFloat adjustH = screenHeight==480?50:0;
    self.addGoodsView.contentViewBottom.constant = kbHeight-adjustH;
    self.addGoodsView.contentViewTop.constant = 2*addGoodsViewBottom-kbHeight+adjustH;
    [UIView animateWithDuration:0.25 animations:^{
        [self.addGoodsView layoutIfNeeded];
    }];
}

- (void)keyboardWillHide:(NSNotification *)noti
{
    self.addGoodsView.contentViewBottom.constant = self.addGoodsView.contentViewTop.constant = addGoodsViewBottom;
    [UIView animateWithDuration:0.25 animations:^{
        [self.addGoodsView layoutIfNeeded];
    }];
}

#pragma mark - UITableViewDataSource&&Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.dataArray objectAtIndex:(section)] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellInden = @"cellInden";
    GoodListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellInden];
    if (!cell) {
        cell = [[GoodListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellInden];
    }
    if (indexPath.row < [[self.dataArray objectAtIndex:(indexPath.section)] count]) {
        cell.model = [[self.dataArray objectAtIndex:(indexPath.section)] objectAtIndex:indexPath.row];
        cell.sepT.hidden = indexPath.row;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    __block GoodsTempList *model = [[self.dataArray objectAtIndex:(indexPath.section)] objectAtIndex:indexPath.row];
    void (^block)() = ^{
        [self.addGoodsView showAnimate:YES];
        self.addGoodsView.model = model;
    };
    
    [[GoodsTempList getUsingLKDBHelper]search:[GoodsTempList class] where:@{@"title":model.title} orderBy:nil offset:0 count:1 callback:^(NSMutableArray *array) {
        if (array.count) {
            model = array[0];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (array.count) {
                [MBProgressHUD showMessage:@"该商品已存在"];
                return ;
            }
            block();
        });
    }];
}

#pragma mark -sectionHeader

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([[self.dataArray objectAtIndex:(section)] count] == 0)
    {
        return 0;
    }
    else{
        return 50;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([[self.dataArray objectAtIndex:(section)] count] == 0)
    {
        return nil;
    }
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 50)];
    [contentView setBackgroundColor:backGroudColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 100, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:17];
    label.textColor = ALTextColor;
    UILocalizedIndexedCollation *indexCollation = [UILocalizedIndexedCollation currentCollation];
    [label setText:[[indexCollation sectionTitles] objectAtIndex:(section)]];
    [contentView addSubview:label];
    return contentView;
}

#pragma mark - GoodInfoModel的本地服务器表里插入新数据
- (void)insertNewGoodsWithModel:(GoodsTempList *)model
{
    __block BOOL isExist = NO;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (GoodsTempList *temp in self.array) {
            if (model.number == temp.number || [temp.title isEqualToString:model.title]) {
                isExist = YES;
                break;
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (isExist) {
                [MBProgressHUD showError:@"该编号已存在,请修改编号"];
            }else{
                [[GoodsTempList getUsingLKDBHelper]insertToDB:model callback:^(BOOL result) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (self.callBack) {
                            self.callBack(model);
                        }
                        [self.addGoodsView hideAnimate:YES];
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                }];
            }
        });
    });
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
