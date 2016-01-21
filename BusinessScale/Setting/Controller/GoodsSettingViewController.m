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
@interface GoodsSettingViewController ()<UITableViewDataSource,UITableViewDelegate,BleDeviceDelegate>

{
    CGFloat addGoodsViewBottom;
    CsBtUtil *_btUtil;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) GoodsAddView *addGoodsView;
@property (nonatomic, strong) GoodsAddView *updateGoodsView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) GoodsInfoModel *model;

@end

@implementation GoodsSettingViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (GoodsAddView *)addGoodsView
{
    if (!_addGoodsView) {
        WS(weakSelf);
        _addGoodsView = [GoodsAddView loadXibView];
        _addGoodsView.frame = [UIScreen mainScreen].bounds;
        _addGoodsView.nameTextField.textChanged = ^(NSString *name){
            [weakSelf nameChanged:name];
        };
        _addGoodsView.callBack = ^(NSInteger tag){
            if (tag == 1002) {
                [weakSelf insertNewGoods];
            }
        };
    }
    return _addGoodsView;
}

- (GoodsAddView *)updateGoodsView
{
    if (!_updateGoodsView) {
        WS(weakSelf);
        _updateGoodsView = [GoodsAddView loadXibView];
        _updateGoodsView.frame = [UIScreen mainScreen].bounds;
        _updateGoodsView.nameTextField.textChanged = ^(NSString *name){
            [weakSelf nameChanged:name];
        };
        _updateGoodsView.callBack = ^(NSInteger tag){
            if ([CsBtUtil getInstance].state<CsScaleStateConnected) {
                [MBProgressHUD showMessage:@"请先连接蓝牙设备"];
                return;
            }
            if (tag == 1002) {
                [weakSelf updateGoods];
            }
        };
    }
    return _updateGoodsView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animateda
{
    [super viewWillDisappear:animateda];
    [self putGoodsIntoSeverce];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initFromXib];
    [self buildNavBarItems];
    [self datas];
}

- (void)initFromXib
{
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
        [weakSelf.addGoodsView showAnimate:YES];
//        [weakSelf navBarRightItemEvent];
    }];
}

- (void)datas
{
    [[GoodsInfoModel getUsingLKDBHelper]search:[GoodsInfoModel class] where:nil orderBy:nil offset:0 count:1000 callback:^(NSMutableArray *array) {
        [self.dataArray addObjectsFromArray:array];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

- (void)navBarRightItemEvent
{
    WS(weakSelf);
    GoodsListController *gct = [[GoodsListController alloc]init];
    gct.stopUpLoad = YES;
    gct.callBack = ^(GoodsInfoModel *model){
        [weakSelf.dataArray addObject:model];
        [weakSelf.tableView reloadData];
    };
    [self.navigationController pushViewController:gct animated:YES];
}
#pragma mark -keyBoardNotice
- (void)keyboardWillShow:(NSNotification *)noti
{
    // 获取键盘的高度
    CGRect kbEndFrm = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat kbHeight =  kbEndFrm.size.height;
    if (self.addGoodsView.superview) {
        [UIView animateWithDuration:0.25 animations:^{
            self.addGoodsView.y = - (kbHeight-addGoodsViewBottom);
        }];
    }else if (self.updateGoodsView.superview){
        [UIView animateWithDuration:0.25 animations:^{
            self.updateGoodsView.y = - (kbHeight-addGoodsViewBottom);
        }];
    }
}

- (void)keyboardWillHide:(NSNotification *)noti
{
    if (self.addGoodsView.superview) {
        self.addGoodsView.goosList.hidden = YES;
        [UIView animateWithDuration:0.25 animations:^{
            self.addGoodsView.y = 0;
        }];
    }else if (self.updateGoodsView.superview){
        self.updateGoodsView.goosList.hidden = YES;
        [UIView animateWithDuration:0.25 animations:^{
            self.updateGoodsView.y = 0;
        }];
    }
}

#pragma mark - netRequest
- (void)putGoodsIntoSeverce
{
    NSMutableArray *dataArray = [NSMutableArray array];
    for (GoodsInfoModel *model in self.dataArray) {
        NSDictionary *dic = [model keyValues];
        [dic setValue:[UnitTool stringFromWeightSeverce:model.unit] forKey:@"unit"];
        [dataArray addObject:dic];
        [[GoodsInfoModel getUsingLKDBHelper]insertToDB:model callback:nil];
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
    _model = self.dataArray[indexPath.row];
    [self.updateGoodsView showAnimate:YES];
    
    self.updateGoodsView.goodsImage.image = [UIImage imageFromSeverName:_model.icon];
    self.updateGoodsView.nameTextField.inputField.text = _model.title;
    self.updateGoodsView.numberTextField.inputField.text = [NSString stringWithFormat:@"%i",[_model.number intValue]];
    self.updateGoodsView.priceTextField.inputField.text = [NSString stringWithFormat:@"%g",_model.unit_price/100.0f];
}

#pragma mark - delegate
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
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
        [weakSelf syChro];
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

#pragma mark - sychoro同步
- (void)syChro
{
    [[GoodsInfoModel getUsingLKDBHelper]search:[GoodsInfoModel class] where:nil orderBy:nil offset:0 count:1000 callback:^(NSMutableArray *array) {
        for (__block GoodsInfoModel *model in array) {
            if (!model.isSychro) {
                SyncUnitPriceFrame *frame = [[SyncUnitPriceFrame alloc] initWithProductId:[model.number intValue] unitPrice:model.unit_price*1000.0f/model.unit withUnit:CsBtUnitKg];
                [_btUtil writeFrameToPeripheral:frame completedBlock:^{
                    model.isSychro = YES;
                }];
                [[GoodsInfoModel getUsingLKDBHelper]updateToDB:model where:nil];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.dataArray removeAllObjects];
            [self datas];
        });
    }];
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
    self.addGoodsView.dataSource = arr;
}

#pragma mark - insert goods
- (void)insertNewGoods
{
    GoodsInfoModel *model = [[GoodsInfoModel alloc]init];
    model.icon = self.addGoodsView.icon;
    model.number = @([self.addGoodsView.numberTextField.inputField.text integerValue]);
    model.title = self.addGoodsView.nameTextField.inputField.text;
    model.unit_price = (NSInteger)([self.addGoodsView.priceTextField.inputField.text floatValue]*100);
    model.unit = self.addGoodsView.currentUnit;
    [[GoodsInfoModel getUsingLKDBHelper]insertToDB:model callback:nil];
    [self.dataArray addObject:model];
    [self.tableView reloadData];
    
    [self.addGoodsView initilize];
}
#pragma mark -修改物品
- (void)updateGoods
{
    _model.title = self.updateGoodsView.nameTextField.inputField.text;
    _model.number = @([self.updateGoodsView.numberTextField.inputField.text integerValue]);
    _model.unit_price = [self.updateGoodsView.priceTextField.inputField.text floatValue]*100;
    _model.unit = self.updateGoodsView.currentUnit;
    [self.tableView reloadData];
}

@end
