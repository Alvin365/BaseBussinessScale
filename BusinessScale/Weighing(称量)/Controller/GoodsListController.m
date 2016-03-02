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
#import "SettingBussiness.h"
#import "ContactsIndexsView.h"
#import "GoodsAddView.h"
#import "GoodsListHttpTool.h"
#import <Commercial-Bluetooth/CsBtUtil.h>
#import "ALSearchBar.h"
#import "ALSearchDisplayController.h"
@interface GoodsListController ()<UITableViewDataSource,UITableViewDelegate,UISearchDisplayDelegate,UISearchBarDelegate>
{
    CGFloat addGoodsViewBottom;
    CsBtUtil *_btUtil;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) ContactsIndexsView *titlesIndexs;
@property (nonatomic, strong) GoodsAddView *addGoodsView;
@property (nonatomic, strong) GoodsAddView *addNewGoodsView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSArray *totalGoods;

@property (nonatomic, strong) ALSearchBar *searchBar;
@property (nonatomic, strong) ALSearchDisplayController *searchController;

@end

@implementation GoodsListController

- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[ALSearchBar alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, 44)];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"请输入关键字搜索";
        _searchBar.backgroundColor = ALNavBarColor;
    }
    
    return _searchBar;
}

- (ALSearchDisplayController *)searchController
{
    if (!_searchController) {
        _searchController = [[ALSearchDisplayController alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-64)];
        _searchController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        __weak GoodsListController *weakSelf = self;
        [_searchController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
            static NSString *CellIdentifier = @"cell";
            GoodListCell *cell = (GoodListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!cell) {
                cell = [[GoodListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            cell.model = weakSelf.searchController.resultsSource[indexPath.row];
            cell.sepT.hidden = indexPath.row;
            return cell;
        }];
        
        [_searchController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return 65;
        }];
        
        [_searchController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            GoodsTempList *model = weakSelf.searchController.resultsSource[indexPath.row];
            [weakSelf.searchBar endEditing:YES];
            [weakSelf.addGoodsView showAnimate:YES];
            weakSelf.addGoodsView.model = model;
        }];
    }
    
    return _searchController;
}

- (NSArray *)totalGoods
{
    if (!_totalGoods) {
        WeightBussiness *business = [[WeightBussiness alloc]init];
        [business getGoodsListCompletedBlock:^(NSArray *array) {
            _totalGoods = array;
        } category:NO];
    }
    return _totalGoods;
}

- (GoodsAddView *)addGoodsView
{
    if (!_addGoodsView) {
        WS(weakSelf);
        _addGoodsView = [GoodsAddView loadXibView];
        _addGoodsView.frame = [UIScreen mainScreen].bounds;
        _addGoodsView.callBack = ^(GoodsTempList *model, BOOL cancle){
            if (cancle) {
                return;
            }
            [weakSelf insertNewGoodsWithModel:model];
        };
    }
    return _addGoodsView;
}

- (GoodsAddView *)addNewGoodsView
{
    if (!_addNewGoodsView) {
        WS(weakSelf);
        _addNewGoodsView = [GoodsAddView loadXibView];
        _addNewGoodsView.frame = [UIScreen mainScreen].bounds;
        _addNewGoodsView.callBack = ^(GoodsTempList *model, BOOL cancle){
            if (cancle) {
                return;
            }
            [weakSelf insertNewGoodsWithModel:model];
        };
    }
    return _addNewGoodsView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildNavBarItems];
    [self buildTableIndexs];
    [self datas];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    _btUtil = [CsBtUtil getInstance];
}

- (void)buildNavBarItems
{
//    WS(weakSelf);
    [self buildBack];
    self.navigationItem.titleView = nil;
    self.title = @"商品列表";
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:[UIImage orignImage:@"search"] style:UIBarButtonItemStylePlain target:self action:@selector(search)];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithImage:[UIImage orignImage:@"icon_add"] style:UIBarButtonItemStylePlain target:self action:@selector(addGood)];
    self.navigationItem.rightBarButtonItems = @[item2,item];
}

- (void)removeNavBarItems
{
    self.navigationItem.rightBarButtonItems = nil;
}
// 列表索引
- (void)buildTableIndexs
{
    WS(weakSelf);
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
    [self.progressHud show:YES];
    WeightBussiness *bussiness = [[WeightBussiness alloc]init];
    [bussiness getGoodsListCompletedBlock:^(NSArray *array) {
        [self.progressHud hide:YES];
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
    } category:YES];
    
    addGoodsViewBottom = 107*ALScreenScalHeight;
    
    [self totalGoods];
}

- (void)search
{
    self.navigationItem.titleView = self.searchBar;
    [self searchController];
    [self removeNavBarItems];
    [self.view addSubview:self.searchController];
    [self.searchBar becomeFirstResponder];
}

- (void)addGood
{
    [self.addNewGoodsView showAnimate:YES];
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
    _searchController.searchResultsTableView.height = screenHeight-kbHeight-64;
    [UIView animateWithDuration:0.25 animations:^{
        if (self.addGoodsView.superview) {
            self.addGoodsView.y = - (kbHeight-addGoodsViewBottom);
        }
        if (self.addNewGoodsView.superview) {
            self.addNewGoodsView.y = - (kbHeight-addGoodsViewBottom);
        }
    }];
}

- (void)keyboardWillHide:(NSNotification *)noti
{
    self.addGoodsView.goosList.hidden = YES;
    [UIView animateWithDuration:0.25 animations:^{
        if (self.addGoodsView.superview) {
            self.addGoodsView.y = 0;
        }
        if (self.addNewGoodsView.superview) {
            self.addNewGoodsView.y = 0;
        }
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
    [self.addGoodsView showAnimate:YES];
    self.addGoodsView.model = model;
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
    [SettingBussiness judgeListHaveThisGoods:model list:self.array completedBlock:^{
        [[GoodsTempList getUsingLKDBHelper]insertToDB:model];
        if (self.callBack) {
            self.callBack(model);
        }
        if (self.addGoodsView.superview) {
            [self.addGoodsView hideAnimate:YES];
        }
        if (self.addNewGoodsView.superview) {
            [self.addNewGoodsView hideAnimate:YES];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.searchController.resultsSource removeAllObjects];
    for (GoodsTempList *model in self.totalGoods) {
        NSString *str = model.title;
        NSRange range = [str rangeOfString:searchText];
        if (range.location!=NSNotFound) {
            [self.searchController.resultsSource addObject:model];
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.searchController.searchResultsTableView reloadData];
    });
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (!self.searchController.resultsSource.count) {
        [MBProgressHUD showMessage:@"没有找到相关商品"];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [self.searchController.resultsSource removeAllObjects];
    self.searchController.searchResultsTableView.height = screenHeight-64;
    [self.searchController.searchResultsTableView reloadData];
    [self.searchController removeFromSuperview];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self buildNavBarItems];
    });
}

@end
