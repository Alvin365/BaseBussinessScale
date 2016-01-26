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

- (GoodsAddView *)updateGoodsView
{
    if (!_updateGoodsView) {
        WS(weakSelf);
        _updateGoodsView = [GoodsAddView loadXibView];
        _updateGoodsView.frame = [UIScreen mainScreen].bounds;
//        _updateGoodsView.nameTextField.textChanged = ^(NSString *name){
//            [weakSelf nameChanged:name];
//        };
        _updateGoodsView.callBack = ^(GoodsTempList *model){
            if (![weakSelf judgeCanUpLoad]) {
                return ;
            }
            [weakSelf updateGoodsWithModel:model];
        };
    }
    return _updateGoodsView;
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
    NSMutableDictionary *sqlDic = [NSMutableDictionary dictionary];
    if ([AccountTool account].ID) [sqlDic setObject:[AccountTool account].ID forKey:@"uid"];
    if ([ScaleTool scale].mac) [sqlDic setObject:[ScaleTool scale].mac forKey:@"mac"];
    [self.dataArray removeAllObjects];
    [[GoodsTempList getUsingLKDBHelper]search:[GoodsTempList class] where:nil orderBy:@"number" offset:0 count:0 callback:^(NSMutableArray *array) {
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
    gct.array = [self.dataArray copy];
    gct.callBack = ^(GoodsTempList *model){
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
    for (GoodsTempList *model in self.dataArray) {
        NSDictionary *dic = [model keyValues];
        [dic setValue:[UnitTool stringFromWeightSeverce:model.unit] forKey:@"unit"];
        [dataArray addObject:dic];
        [[GoodsTempList getUsingLKDBHelper]insertToDB:model callback:nil];
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

- (void)postListWithArray:(NSArray *)syChroArray
{
    NSMutableArray *arr = [NSMutableArray array];
    for (GoodsTempList *model in syChroArray) {
        NSDictionary *dic = [model keyValues];
        [dic setValue:[UnitTool stringFromWeightSeverce:model.unit] forKey:@"unit"];
        [arr addObject:dic];
    }
    [self.progressHud show:YES];
    GoodsListHttpTool *req = [[GoodsListHttpTool alloc]initWithParam:[GoodsListHttpTool postCoodsListSeverse:arr]];
    [req setReturnBlock:^(NSURLSessionTask *task, NSURLResponse *response, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self doDatasFromNet:responseObject useFulData:^(NSObject *data) {
                if (data) {
                    for (GoodsTempList *model in syChroArray) {
                        model.isSychro = YES;
                    }
                    [self.tableView reloadData];
                }
            }];
        });
    }];
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
        [[GoodsTempList getUsingLKDBHelper]deleteToDB:self.dataArray[indexPath.row] callback:nil];
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    }
}

#pragma mark -sectionHeader
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    WS(weakSelf);
    GoodsHeader *header = [GoodsHeader loadXibView];
    header.callBack = ^{
        [weakSelf syChrosize];
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
- (void)insertNewGoodsWith:(GoodsTempList *)model
{
    if (![self judgeCanUpLoad]) {
        return;
    }
    [self datas];
}

#pragma mark -修改物品
- (void)updateGoodsWithModel:(GoodsTempList *)model
{
    if (![self judgeCanUpLoad]) {
        return;
    }
    [self.dataArray removeObject:model];
    __block BOOL isExist = NO;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (GoodsTempList *temp in self.dataArray) {
            if (model.number == temp.number || [temp.title isEqualToString:model.title]) {
                isExist = YES;
                break;
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (isExist) {
                [MBProgressHUD showError:@"该编号或名称已存在"];
                [self datas];
            }else{
                [[GoodsTempList getUsingLKDBHelper]updateToDB:model where:nil];
                model.isSychro = NO;
                [self datas];
                [self.updateGoodsView hideAnimate:YES];
            }
        });
    });
    
    
//    SyncUnitPriceFrame *frame = [[SyncUnitPriceFrame alloc] initWithProductId:[model.number intValue] unitPrice:model.unit_price*1000.0f/model.unit withUnit:CsBtUnitKg];
//WS(weakSelf);
//    __block typeof (GoodsInfoModel *)blockModel = model;
//    _btUtil.writeToFrameBlock = ^(BOOL isWrite){
//        if (!isWrite) {
//            showAlert(@"同步到蓝牙失败，请重新连接蓝牙设备，必要时重启蓝牙设备");
//            return;
//        }
//        model.isSychro = YES;
//        [[GoodsTempList getUsingLKDBHelper]insertToDB:model];
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
    NSMutableArray *syChroArray = [NSMutableArray array];
    for (GoodsTempList *model in self.dataArray) {
        if (!model.isSychro) {
//            SyncUnitPriceFrame *frame = [[SyncUnitPriceFrame alloc] initWithProductId:[model.number intValue] unitPrice:model.unit_price*1000.0f/model.unit withUnit:CsBtUnitKg];
//            __block typeof (GoodsInfoModel *)blockModel = model;
//            _btUtil.writeToFrameBlock = ^(BOOL isWrite){
//                if (!isWrite) {
//                    showAlert(@"同步到蓝牙失败，请重新连接蓝牙设备，必要时重启蓝牙设备");
//                    return;
//                }
//                model.isSychro = YES;
//                [[GoodsTempList getUsingLKDBHelper]insertToDB:model];
//                [self.tableView reloadData];
//                [self.updateGoodsView hideAnimate:YES];
//            };
//            [_btUtil writeFrameToPeripheral:frame];
            [syChroArray addObject:model];
        }
    }
    [self postListWithArray:syChroArray];
}

@end
