//
//  WeighingViewController.m
//  BusinessScaleBase
//
//  Created by Alvin on 15/12/15.
//  Copyright © 2015年 chipsea. All rights reserved.
//

#import "WeighingViewController.h"
#import "GoodsSwapCell.h"
#import "PalletViewController.h"
#import "ALNavigationController.h"
#import "GoodsListController.h"
#import "PayWaySelectView.h"
#import "WeightNoDatasView.h"
#import "WeightHttpTool.h"
#import "LoginHttpTool.h"
#import "WeightBussiness.h"
#import "LocalDataTool.h"
@interface WeighingViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *SepView;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UILabel *unitL;
@property (weak, nonatomic) IBOutlet UIImageView *goodImage;
@property (weak, nonatomic) IBOutlet UIButton *putInBtn;
@property (weak, nonatomic) IBOutlet UIButton *payMoneyBtn;
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UILabel *weightL;

@property (nonatomic, strong) PayWaySelectView *paySelectView;
@property (nonatomic, strong) WeightNoDatasView *noDatasView;

#pragma mark -layoutConstraint
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *putInTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *putInHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *putInWith;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sepTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sepHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodImageTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodsImageWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodsImageHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodsNameHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *weightLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payMoneyTailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *weightTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceTailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodImageLeading;

@end

@implementation WeighingViewController

- (PayWaySelectView *)paySelectView
{
    if (!_paySelectView) {
        WS(weakSelf);
        _paySelectView = [PayWaySelectView loadXibView];
        _paySelectView.frame = [UIScreen mainScreen].bounds;
        _paySelectView.callBack = ^(PayWayType type){
            if (type == PayWayTypeCrash) {
                SaleTable *saleT = [[SaleTable alloc]init];
                saleT.total_fee = 20.5;
                saleT.paid_fee = 19.5;
                saleT.randid = [NSString radom11BitString];
                saleT.ts = [NSDate date].timeStempString;
                saleT.title = @"苹果等";
                saleT.payment_type = @"Wechat";
                NSMutableArray *arr = [NSMutableArray array];
                for (int i = 0; i<3; i++) {
                    SaleItem *item = [[SaleItem alloc]init];
                    item.title = @[@"苹果",@"雪碧",@"手机"][i];
                    item.unit = @"g";
                    item.unit_price = 200.0f;
                    item.ts = [NSDate date].timeStempString;
                    item.quantity = 2;
                    [arr addObject:item];
                }
                saleT.items = arr;
                WeightBussiness *bussiness = [[WeightBussiness alloc]init];
                [bussiness saveSaleToDb:saleT];
                [weakSelf uploadRecords];
            }else if (type == PayWayTypeAlipay){
                NSMutableArray *params = [NSMutableArray array];
                [[SaleTable getUsingLKDBHelper] search:[SaleTable class] where:nil orderBy:nil offset:0 count:100 callback:^(NSMutableArray *array) {
                    for (SaleTable *t in array) {
                        if (!t.isUpLoad) {
                            [params addObject:[t keyValues]];
                        }
                    }
//                    NSData *data = [NSData ]
                    WeightHttpTool *request = [[WeightHttpTool alloc]initWithParam:[WeightHttpTool batchUploadSaleRecords:params]];
                    [request setReturnBlock:^(NSObject *obj) {
                        
                    }];
                }];
            }
        };
    }
    return _paySelectView;
}

- (WeightNoDatasView *)noDatasView
{
    if (!_noDatasView) {
        _noDatasView = [WeightNoDatasView loadXibView];
        _noDatasView.frame = self.view.bounds;
        [self.view addSubview:_noDatasView];
    }
    return _noDatasView;
}

- (IBAction)btnClick:(id)sender
{
    if ([sender tag]) {
        [self.paySelectView showAnimate:YES];
    }else{
        [self.progressHud show:YES];
        LoginHttpTool *request = [[LoginHttpTool alloc]initWithParam:[LoginHttpTool loginWithParams:nil]];
        [request setReturnBlock:^(NSObject *obj) {
            ALLog(@"%@",obj);
//            if ([obj isKindOfClass:[AFHTTPRequestSerializer class]]) {
//                AFHTTPRequestOperation *o = (AFHTTPRequestOperation *)obj;
//                NSDictionary *dic = o.response.allHeaderFields;
//                AccountModel *model = [[AccountModel alloc]init];
//                model.token = dic[@"cs-token"];
//                model.expirytime = dic[@"cs-token-expirytime"];
//                [AccountTool saveAccount:model];
//                [self doDatasFromNet:o.responseObject useFulData:^(NSObject *data) {
//                    if (data) {
//                        ALLog(@"%@",data);
//                    }
//                }];
//                ALLog(@"%@",o);
//            }
            
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initFromXib];
    [self buildNavBarItems];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(SWTableViewCellScrollNotice:) name:SWTableViewCellBeginScrollNotice object:nil];
    [self.noDatasView showAnimate:YES];
}

- (void)initFromXib
{
    CGFloat scale = 1.0f; // 调整4s的间距用
    self.putInTop.constant = 30*ALScreenScalHeight*scale;
    self.putInWith.constant = 120*ALScreenScalWidth;
    self.putInHeight.constant = 55*ALScreenScalWidth;
    self.weightLeading.constant = 42.5*ALScreenScalWidth;
    self.goodImageTop.constant = 30*ALScreenScalHeight*scale;
    self.goodsImageWidth.constant = 65*ALScreenScalWidth;
    self.goodsImageHeight.constant = 65*ALScreenScalWidth;
//    self.goodsNameHeight.constant = 40;
    self.sepTop.constant = 30*ALScreenScalHeight*scale;
    self.sepHeight.constant = 60*ALScreenScalHeight*scale;
    self.payMoneyTailing.constant = 42.5*ALScreenScalWidth;
    self.weightTop.constant = 20*ALScreenScalHeight*scale;
    
    /**
     * 图片和价格居中显示
     */
    CGFloat width = [self.priceL.text bundingWithSize:CGSizeMake(screenWidth, 50*ALScreenScalWidth) Font:50*ALScreenScalWidth].width;
    width = screenWidth-(width+self.goodsImageWidth.constant+40);
    self.goodImageLeading.constant = width/2.0f;
    self.priceTailing.constant = width/2.0f;
    
    _goodImage.layer.cornerRadius = 32.5f*ALScreenScalWidth;
    _goodImage.layer.masksToBounds = YES;
    _unitL.textColor = ALTextColor;
    _priceL.textColor = ALTextColor;
    _priceL.font = [UIFont systemFontOfSize:50*ALScreenScalWidth];
    
    UIColor *color = ALLightTextColor;
    _weightL.textColor = color;
    _weightL.layer.borderColor = color.CGColor;
    _weightL.layer.borderWidth = 0.7;
    _weightL.layer.cornerRadius = 5;
    _weightL.clipsToBounds = YES;
    
    _putInBtn.layer.cornerRadius = (55*ALScreenScalWidth)/2.0f;
    _putInBtn.backgroundColor = [UIColor colorWithHexString:@"90bf46"];
    _payMoneyBtn.layer.cornerRadius = (55*ALScreenScalWidth)/2.0f;
    _payMoneyBtn.backgroundColor = ALRedColor;
    _payMoneyBtn.layer.masksToBounds = YES;
    _putInBtn.layer.masksToBounds = YES;
    
    _totalPrice.backgroundColor = [UIColor clearColor];
    _totalPrice.attributedText = [ALCommonTool setAttrbute:@"总价：" andAttribute:@"26.4元" Color1:ALTextColor Color2:ALTextColor Font1:15 Font2:22];
    
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    _table.delegate = self;
    _table.dataSource = self;
    
    _SepView.backgroundColor = backGroudColor;
    UILabel *l = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 0.5)];
    l.backgroundColor = separateLabelColor;
    [_SepView addSubview:l];
}

- (void)buildNavBarItems
{
    WS(weakSelf);
    self.navigationItem.title = @"OKOK计量";
    
    [self addNavLeftBarBtn:@"进入托盘" selectorBlock:^{
//        PalletViewController *pctl = [[PalletViewController alloc]init];
        GoodsListController *pctl = [[GoodsListController alloc]init];
        [weakSelf.navigationController pushViewController:pctl animated:YES];
    }];
    
    [self addNavRightBarBtn:@"蓝牙已连接" selectorBlock:^{
        [weakSelf.noDatasView hideAnimate:YES];
    }];
}

- (void)datas
{
    
}

#pragma mark -URLRequest
- (void)uploadRecords
{
    NSDictionary *params = @{@"randid":@"111",@"ts":[NSDate date].timeStempString,@"title":@"fsaf",@"total_fee":@"1",@"paid_fee":@"2",@"payment_type":@"cash",@"items":@[@{@"title":@"苹果",@"unit":@"g",@"unit_price":@"1",@"quantity":@"2"}]};
    WeightHttpTool *request = [[WeightHttpTool alloc]initWithParam:[WeightHttpTool uploadSaleRecord:params]];
    [request setReturnBlock:^(NSObject *obj) {
        
    }];
}
#pragma mark - UITableViewDelegate&&DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIden = @"cell";
    GoodsSwapCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIden];
    if (!cell) {
        NSMutableArray *rightUtilityButtons = [NSMutableArray array];
        [rightUtilityButtons addUtilityButtonWithColor:[UIColor redColor] title:@"删除"];
        tableView.rowHeight = 70*ALScreenScalHeight;
        cell = [[GoodsSwapCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                    reuseIdentifier:cellIden
                                containingTableView:tableView
                                 leftUtilityButtons:nil
                                rightUtilityButtons:rightUtilityButtons];
    }
    return cell;
}

#pragma mark - Notice
- (void)SWTableViewCellScrollNotice:(NSNotification *)notice
{
    static SWTableViewCell *formerCell = nil;
    SWTableViewCell *currentCell = (SWTableViewCell *)notice.object;
    if (formerCell != currentCell) {
        [formerCell hideUtilityButtonsAnimated:YES];
    }
    formerCell = currentCell;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
