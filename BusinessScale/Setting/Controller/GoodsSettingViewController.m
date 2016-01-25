//
//  GoodsSettingViewController.m
//  BusinessScale
//
//  Created by Alvin on 15/12/18.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import "GoodsSettingViewController.h"
#import "GoodsSettingCell.h"
#import "GoodsHeader.h"
#import "GoodsAddView.h"
#import "LocalDataTool.h"
#import <Commercial-Bluetooth/CsBtUtil.h>
#import "GoodsListHttpTool.h"
#import "GoodsListController.h"
#import "Reachability.h"
@interface GoodsSettingViewController ()<UITableViewDataSource,UITableViewDelegate>

{
    CGFloat addGoodsViewBottom;
    CsBtUtil *_btUtil;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//@property (nonatomic, strong) GoodsAddView *addGoodsView;
@property (nonatomic, strong) GoodsAddView *updateGoodsView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation GoodsSettingViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

//- (GoodsAddView *)addGoodsView
//{
//    if (!_addGoodsView) {
//        WS(weakSelf);
//        _addGoodsView = [GoodsAddView loadXibView];
//        _addGoodsView.frame = [UIScreen mainScreen].bounds;
//        _addGoodsView.nameTextField.textChanged = ^(NSString *name){
//            [weakSelf nameChanged:name];
//        };
//        _addGoodsView.callBack = ^(NSInteger tag){
//            if (tag == 1002) {
//                if (![weakSelf judgeCanUpLoad]) {
//                    return;
//                }
//                [weakSelf insertNewGoods];
//            }
//        };
//    }
//    return _addGoodsView;
//}

- (GoodsAddView *)updateGoodsView
{
    if (!_updateGoodsView) {
        WS(weakSelf);
        _updateGoodsView = [GoodsAddView loadXibView];
        _updateGoodsView.frame = [UIScreen mainScreen].bounds;
        _updateGoodsView.nameTextField.textChanged = ^(NSString *name){
            [weakSelf nameChanged:name];
        };
        _updateGoodsView.callBack = ^(GoodsInfoModel *model){
            if (![weakSelf judgeCanUpLoad]) {
                return ;
            }
            [weakSelf updateGoodsWithModel:model];
        };
    }
    return _updateGoodsView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initFromXib];
    [self buildNavBarItems];
    [self datas];
}

- (void)initFromXib
{
    _btUtil = [CsBtUtil getInstance];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"GoodsSettingCell" bundle:nil] forCellReuseIdentifier:@"cellInden"];
    self.title = @"商品设置";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    addGoodsViewBottom = 107*ALScreenScalHeight;
}

- (void)buildNavBarItems
{
    WS(weakSelf);
    [self addNavRightBarBtn:@"icon_add" selectorBlock:^{
//        [weakSelf.addGoodsView showAnimate:YES];
        [weakSelf navBarRightItemEvent];
    }];
}

- (void)datas
{
    [[GoodsTemp getUsingLKDBHelper]search:[GoodsTemp class] where:@{@"uid":[AccountTool account].ID,@"mac":[ScaleTool scale].mac} orderBy:nil offset:0 count:1000 callback:^(NSMutableArray *array) {
        [self.dataArray addObjectsFromArray:array];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

- (void)navBarRightItemEvent
{
    WS(weakSelf);
    if (![self judgeCanUpLoad]) {
        return;
    }
    GoodsListController *gct = [[GoodsListController alloc]init];
    gct.callBack = ^(GoodsTemp *model){
        [weakSelf insertNewGoodsWith:model];
    };
    [self.navigationController pushViewController:gct animated:YES];
}
#pragma mark -keyBoardNotice
- (void)keyboardWillShow:(NSNotification *)noti
{
    // 获取键盘的高度
    CGRect kbEndFrm = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat kbHeight =  kbEndFrm.size.height;
//    if (self.addGoodsView.superview) {
//        [UIView animateWithDuration:0.25 animations:^{
//            self.addGoodsView.y = - (kbHeight-addGoodsViewBottom);
//        }];
//    }else if (self.updateGoodsView.superview){
        [UIView animateWithDuration:0.25 animations:^{
            self.updateGoodsView.y = - (kbHeight-addGoodsViewBottom);
        }];
//    }
}

- (void)keyboardWillHide:(NSNotification *)noti
{
//    if (self.addGoodsView.superview) {
//        self.addGoodsView.goosList.hidden = YES;
//        [UIView animateWithDuration:0.25 animations:^{
//            self.addGoodsView.y = 0;
//        }];
//    }else if (self.updateGoodsView.superview){
        self.updateGoodsView.goosList.hidden = YES;
        [UIView animateWithDuration:0.25 animations:^{
            self.updateGoodsView.y = 0;
        }];
//    }
}

#pragma mark - netRequest
- (void)putGoodsIntoSeverce
{
    NSMutableArray *dataArray = [NSMutableArray array];
    for (GoodsTemp *model in self.dataArray) {
        NSDictionary *dic = [model keyValues];
        [dic setValue:[UnitTool stringFromWeightSeverce:model.unit] forKey:@"unit"];
        [dataArray addObject:dic];
        [[GoodsTemp getUsingLKDBHelper]insertToDB:model callback:nil];
    }
//    if ([ALCommonTool haveNewGoods:dataArray.count]) {
        GoodsListHttpTool *req = [[GoodsListHttpTool alloc]initWithParam:[GoodsListHttpTool coverCoodsListSeverse:dataArray]];
        [req setReturnBlock:^(NSURLSessionTask *task, NSURLResponse *response, id responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self doDatasFromNet:responseObject useFulData:^(NSObject *data) {
                    if (data) {

                    }
                }];
            });
        }];
//    }
}

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellInden = @"cellInden";
    GoodsSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellInden];
    if (!cell) {
        cell = [[GoodsSettingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellInden];
    }
    if (indexPath.row < self.dataArray.count) {
        cell.model = self.dataArray[indexPath.row];
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
    if (![self judgeCanUpLoad]) {
        return;
    }
    [self.updateGoodsView showAnimate:YES];
    self.updateGoodsView.model = self.dataArray[indexPath.row];
}

#pragma mark - delegate 删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[GoodsTemp getUsingLKDBHelper]deleteToDB:self.dataArray[indexPath.row] callback:nil];
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    }
}

#pragma mark -sectionHeader
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    GoodsHeader *header = [GoodsHeader loadXibView];
    header.callBack = ^{
    
    };
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 130;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
#pragma mark -nameChangedEvent
-  (void)nameChanged:(NSString *)name
{
    NSMutableArray *arr = [NSMutableArray array];
    NSDictionary *dic = [LocalDataTool getGoodsList];
    NSArray *keys = dic.allKeys;
    for (NSString *string in keys) {
        NSRange range = [string rangeOfString:name];
        if (range.location!=NSNotFound) {
            NSDictionary *temp = @{string:dic[string]};
            [arr addObject:temp];
        }
    }
    self.updateGoodsView.dataSource = arr;
}

#pragma mark - insert goods 新增物品
- (void)insertNewGoodsWith:(GoodsTemp *)model
{
    if (![self judgeCanUpLoad]) {
        return;
    }
//    [self.progressHud show:YES];
//    WS(weakSelf);
//    SyncUnitPriceFrame *frame = [[SyncUnitPriceFrame alloc] initWithProductId:[model.number intValue] unitPrice:model.unit_price*1000.0f/model.unit withUnit:CsBtUnitKg];
//    _btUtil.writeToFrameBlock = ^(BOOL isWrite){
//        if (!isWrite) {
//            showAlert(@"同步到蓝牙失败，请重新连接蓝牙设备，必要时重启蓝牙设备");
//            return;
//        }
//        model.isSychro = YES;
        [self.dataArray addObject:model];
        [[GoodsTemp getUsingLKDBHelper]insertToDB:model];
        [self.tableView reloadData];
//    };
//    [_btUtil writeFrameToPeripheral:frame];
//    [self.progressHud hide:YES];
}

#pragma mark -修改物品
- (void)updateGoodsWithModel:(GoodsTemp *)model
{
    if (![self judgeCanUpLoad]) {
        return;
    }
    
    [[GoodsTemp getUsingLKDBHelper]search:[GoodsTemp class] where:@[@{@"number":model.number},@{@"title":model.title}] orderBy:nil offset:0 count:1 callback:^(NSMutableArray *array) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (array.count) {
                [MBProgressHUD showError:@"该编号或名称已存在"];
                return ;
            }else{
                [[GoodsTemp getUsingLKDBHelper]insertToDB:model];
                model.isSychro = NO;
                [self.tableView reloadData];
                [self.updateGoodsView hideAnimate:YES];
            }
        });
    }];
//    SyncUnitPriceFrame *frame = [[SyncUnitPriceFrame alloc] initWithProductId:[model.number intValue] unitPrice:model.unit_price*1000.0f/model.unit withUnit:CsBtUnitKg];
//WS(weakSelf);
//    __block typeof (GoodsInfoModel *)blockModel = model;
//    _btUtil.writeToFrameBlock = ^(BOOL isWrite){
//        if (!isWrite) {
//            showAlert(@"同步到蓝牙失败，请重新连接蓝牙设备，必要时重启蓝牙设备");
//            return;
//        }
//        model.isSychro = YES;
//        [[GoodsTemp getUsingLKDBHelper]insertToDB:model];
//        [self.tableView reloadData];
//    [self.updateGoodsView hideAnimate:YES];
//    };
//    [_btUtil writeFrameToPeripheral:frame];
}

- (BOOL)judgeCanUpLoad
{
    BOOL b = YES;
//    if ([CsBtUtil getInstance].state < CsScaleStateConnected) {
//        [MBProgressHUD showError:@"蓝牙未连接，请先连接设备"];
//        b = NO;
//    }
//    
//    if ([Reachability shareReachAbilty].currentReachabilityStatus == NotReachable) {
//        [MBProgressHUD showError:@"当前网络不好，请重选网络再试"];
//        b = NO;
//    }
    return b;
}
#pragma mark -同步
- (void)syChrosize
{
    WS(weakSelf);
    for (GoodsTemp *model in self.dataArray) {
        if (!model.isSychro) {
            SyncUnitPriceFrame *frame = [[SyncUnitPriceFrame alloc] initWithProductId:[model.number intValue] unitPrice:model.unit_price*1000.0f/model.unit withUnit:CsBtUnitKg];
            __block typeof (GoodsInfoModel *)blockModel = model;
            _btUtil.writeToFrameBlock = ^(BOOL isWrite){
                if (!isWrite) {
                    showAlert(@"同步到蓝牙失败，请重新连接蓝牙设备，必要时重启蓝牙设备");
                    return;
                }
                model.isSychro = YES;
                [[GoodsTemp getUsingLKDBHelper]insertToDB:model];
                [self.tableView reloadData];
                [self.updateGoodsView hideAnimate:YES];
            };
            [_btUtil writeFrameToPeripheral:frame];
        }
    }
}

@end
