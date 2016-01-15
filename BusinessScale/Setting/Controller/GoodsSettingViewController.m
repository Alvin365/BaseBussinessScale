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
@interface GoodsSettingViewController ()<UITableViewDataSource,UITableViewDelegate,BleDeviceDelegate>

{
    CGFloat addGoodsViewBottom;
    CsBtUtil *_btUtil;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) GoodsAddView *addGoodsView;

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
        for (GoodsInfoModel *model in array) {
            if (!model.isSychro) {
                SyncUnitPriceFrame *frame = [[SyncUnitPriceFrame alloc] initWithProductId:[model.number intValue] unitPrice:model.unit_price*1000.0f/model.unit withUnit:CsBtUnitKg];
                [_btUtil writeFrameToPeripheral:frame];
                model.isSychro = YES;
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
    [[GoodsInfoModel getUsingLKDBHelper]insertToDB:model callback:^(BOOL result) {
        
    }];
    [self.dataArray addObject:model];
    [self.tableView reloadData];
}

@end
