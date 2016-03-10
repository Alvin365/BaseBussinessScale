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
#import "SettingBussiness.h"
@interface GoodsSettingViewController ()<UITableViewDataSource,UITableViewDelegate>

{
    CGFloat addGoodsViewBottom;
    CsBtUtil *_btUtil;
    NSInteger _currentIndex;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NoDataView *noDataView;
@property (nonatomic, strong) GoodsAddView *updateGoodsView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *currentArray; // 正在上传的物品列表
@end

@implementation GoodsSettingViewController

- (NoDataView *)noDataView
{
    if (!_noDataView) {
        _noDataView = [NoDataView loadXibView];
        _noDataView.frame = CGRectMake(0, 130, screenWidth, screenHeight-130-64);
    }
    return _noDataView;
}

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
        _updateGoodsView.callBack = ^(GoodsTempList *model,BOOL cancle){
            if (cancle) {
                [weakSelf initDatas];
                return;
            }
//            if (![weakSelf judgeCanUpLoad]) {
//                return ;
//            }
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
    [self addNavRightBarBtn:@"添加" selectorBlock:^{
//        [weakSelf.addGoodsView showAnimate:YES];==
        [weakSelf navBarRightItemEvent];
    }];
}

- (void)datas
{
    [self initDatas];
    _currentIndex = 0;
    _currentArray = [[NSMutableArray alloc]init];
}

- (void)initDatas
{
    [self.dataArray removeAllObjects];
    [SettingBussiness searchGoodsettingList:^(NSArray *unDeleteArray, NSArray *deletedArray) {
        [self.dataArray addObjectsFromArray:unDeleteArray];
        [self.dataArray addObjectsFromArray:deletedArray];
        if (!_dataArray.count) {
            [self.tableView addSubview:self.noDataView];
        }else{
            [self.noDataView removeFromSuperview];
        }
        [self.tableView reloadData];
    }];
}

- (void)navBarRightItemEvent
{
    WS(weakSelf);
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
    [UIView animateWithDuration:0.25 animations:^{
        self.updateGoodsView.y = - (kbHeight-addGoodsViewBottom);
    }];
}

- (void)keyboardWillHide:(NSNotification *)noti
{
    self.updateGoodsView.goosList.hidden = YES;
    [UIView animateWithDuration:0.25 animations:^{
        self.updateGoodsView.y = 0;
    }];
}

#pragma mark - netRequest
- (void)postListWithDic:(NSDictionary *)uploadDic
{
    [self.progressHud show:YES];
    GoodsListHttpTool *req = [[GoodsListHttpTool alloc]initWithParam:[GoodsListHttpTool coverCoodsListSeverse:uploadDic]];
    [req setReturnBlock:^(NSURLSessionTask *task, NSURLResponse *response, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self doDatasFromNet:responseObject useFulData:^(NSObject *data) {
                if (data) {
                    [LKDBHelper clearTableData:[GoodsInfoModel class]];
                    for (GoodsTempList *model in _dataArray) {
                        if (model.isDelete) {
                            [[GoodsTempList getUsingLKDBHelper]deleteToDB:model];
                        }else{
                            [[GoodsTempList getUsingLKDBHelper]updateToDB:model where:nil];
                            GoodsInfoModel *GoodsInfo = [[GoodsInfoModel alloc]init];
                            [GoodsInfo setValuesForKeysWithDictionary:[model keyValues]];
                            BOOL b = [[GoodsInfoModel getUsingLKDBHelper]insertWhenNotExists:GoodsInfo];
                            if (b) {
                                ALLog(@"插入成功");
                            }else{
                                ALLog(@"插入失败");
                            }
                        }
                    }
                    [self initDatas];
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    GoodsTempList *model = self.dataArray[indexPath.row];
    if (model.isDelete) {
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.updateGoodsView showAnimate:YES];
    self.updateGoodsView.model = model;
}

#pragma mark - delegate 删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataArray[indexPath.row] isDelete]) {
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        GoodsTempList *model = self.dataArray[indexPath.row];
            model.isSychro = NO;
            model.isDelete = YES;
            [[GoodsTempList getUsingLKDBHelper]updateToDB:model where:nil callback:^(BOOL result) {
                [self initDatas];
            }];
    }
}

#pragma mark -sectionHeader
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    WS(weakSelf);
    __weak CsBtUtil *weakBtUtil = _btUtil;
    GoodsHeader *header = [GoodsHeader loadXibView];
    header.callBack = ^{
        if (![self judgeCanUpLoad]) return;
        TransactionDataReqFrame *reqFrame = [[TransactionDataReqFrame alloc] init];
        [_btUtil writeFrameToPeripheral:reqFrame historyBlock:^(NSArray *histories) {
            [weakBtUtil writeFrameToPeripheral:[[ResetDataReqFrame alloc] init]];
            // 同步单价
            [weakSelf syChrosize];
        }];
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
    [self initDatas];
}

#pragma mark -修改物品
- (void)updateGoodsWithModel:(GoodsTempList *)model
{
    [self.dataArray removeObject:model];
    
    [SettingBussiness judgeListHaveThisGoods:model list:self.dataArray completedBlock:^{
        model.isSychro = NO;
        [[GoodsTempList getUsingLKDBHelper]updateToDB:model where:nil];
        [self initDatas];
        [self.updateGoodsView hideAnimate:YES];
    }];
}

- (BOOL)judgeCanUpLoad
{
    BOOL b = YES;
    if ([CsBtUtil getInstance].state != CsScaleStateConnected) {
        [MBProgressHUD showError:@"蓝牙未连接，请先连接设备"];
        b = NO;
    }
    
    if ([Reachability shareReachAbilty].currentReachabilityStatus == NotReachable) {
        [MBProgressHUD showError:@"当前网络不好，请重选网络再试"];
        b = NO;
    }
    return b;
}
#pragma mark -同步
- (void)syChrosize
{
    [_currentArray removeAllObjects];
    for (NSInteger j = _currentIndex;j<_currentIndex+3&&j<self.dataArray.count;j++) {
        GoodsTempList *model = self.dataArray[j];
        [_currentArray addObject:model];
    }
    if (!_currentArray.count) {
        // 结束同步成功事件
        void (^endSucceessBlock)() = ^{
            // 上传云端
            _currentIndex = 0;
            NSMutableDictionary *uploadDic = [NSMutableDictionary dictionary];
//            ALLog(@"蓝牙同步单价成功");
            for (GoodsTempList *model in self.dataArray) {
                if (!model.isDelete) {
                    model.isSychro = 1;
                    NSDictionary *dic = [model keyValues];
                    [dic setValue:[UnitTool stringFromWeightSeverce:model.unit] forKey:@"unit"];
                    [uploadDic setObject:dic forKey:[NSString stringWithFormat:@"%i",(int)model.number]];
                }
            }
            [self postListWithDic:uploadDic];
        };
        // 结束同步失败事件
        void (^endFailureBlock)() = ^{
            SyncUnitPriceFrame *endFrame = [SyncUnitPriceFrame endSyncFrame];
            [_btUtil writeFrameToPeripheral:endFrame completedBlock:^(BOOL succeess, Byte xorValue,NSInteger errorCount) {
                if (succeess) {
                    endSucceessBlock();
                    ALLog(@"蓝牙同步单价成功");
                }else{
                    if (errorCount>=5) {
                        [MBProgressHUD showError:@"同步失败，请检查蓝牙是否连接正常，必要时可重启设备"];
                        return;
                    }
                    endFailureBlock();
                }
            }];
        };
        endFailureBlock();
        
        return;
    };
    
    [self.progressHud show:YES];
    GoodsTempList *product_one = _currentArray.count?_currentArray[0]:nil;
    GoodsTempList *product_two = _currentArray.count>1?_currentArray[1]:nil;
    GoodsTempList *product_three = _currentArray.count>2?_currentArray[2]:nil;
    
    ALLog(@"productOnePrice = %.2f",(product_one.unit_price*10.0f/product_one.unit));
    
    SyncUnitPriceFrame *beginFrame = [SyncUnitPriceFrame beginSyncFrame];
    
    SyncUnitPriceFrame *frame = [[SyncUnitPriceFrame alloc] initWithProductId:(int)product_one.number
                                                                    unitPrice:(product_one.unit_price*10.0f/product_one.unit)
                                                                   productId1:product_two?(int)product_two.number:0
                                                                   unitPrice1:product_two?(product_two.unit_price*10.0f/product_two.unit):0
                                                                   productId2:product_three?(int)product_three.number:0
                                                                   unitPrice2:product_three?(product_three.unit_price*1000.0f/product_three.unit):0];
    // 开始同步成功事件
    void (^beginSucceessBlock) () = ^{
        // 数据同步成功事件
        void (^middleSucceessBlock)() = ^{
            _currentIndex += _currentArray.count;
            [self syChrosize];
        };
        // 数据同步失败事件
        void (^middleFailureBlock)() = ^{
            [_btUtil writeFrameToPeripheral:frame completedBlock:^(BOOL succeess, Byte xorValue,NSInteger errorCount) {
                if (succeess) {
                    middleSucceessBlock();
                }else{
                    if (errorCount>=5) {
                        [MBProgressHUD showError:@"同步失败，请检查蓝牙是否连接正常，必要时可重启设备"];
                        return;
                    }
                    middleFailureBlock(); // 写失败后重写
                }
            }];
        };
        middleFailureBlock();
    };
    // 开始同步失败事件
    void (^beginFailureBlock)() = ^{
        [_btUtil writeFrameToPeripheral:beginFrame completedBlock:^(BOOL succeess, Byte xorValue, NSInteger errorCount) {
            if (succeess) {
                beginSucceessBlock();
            }else{
                if (errorCount>=5) {
                    [MBProgressHUD showError:@"同步失败，请检查蓝牙是否连接正常，必要时可重启设备"];
                    return;
                }
                beginFailureBlock();
            }
        }];
    };
    beginFailureBlock();
}

@end
