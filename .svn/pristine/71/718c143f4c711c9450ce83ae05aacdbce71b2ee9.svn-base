//
//  DeviceInformationController.m
//  btWeigh
//
//  Created by ChipSea on 15/6/18.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "DeviceInformationController.h"


@interface DeviceInformationController ()

@end

@implementation DeviceInformationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAll];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //国际化
    self.title = DPLocalizedString(@"scale_info", @"设备信息");
}

-(void)initAll {
    ALLog(@"DeviceInfomationController -> initAll");
    // 色差
    _kUIFirm.layer.borderColor = Color(229, 228, 233,1).CGColor;
    _kUITel.layer.borderColor = Color(229, 228, 233,1).CGColor;
    _kUIAddress.layer.borderColor = Color(229, 228, 233,1).CGColor;
    _kUIFirm.textColor = Color(0, 0, 0, .9);
    _kUITel.textColor = Color(0, 0, 0, .9);
    _kUIAddress.textColor = Color(0, 0, 0.0,1);
//    if ([UserDefaultUtil getCurScale].product_id == 0) {
//        [self resetViewController];
//        return;
//    }
//    if ([UserDefaultUtil getCurNetworkStatus] == CsNetworkStatusWifi) {
//        [_business getProductInfoLogical];
//    } else {
//        NSDictionary *infoDic = [_business getProductInfoFromCache];
//        if (infoDic != nil) {
//            NSString *language = [CommonUtil getPreferredLanguage];
//            if (language.length > 2) {
//                language = [language substringToIndex:2];
//            }
//            NSDictionary *productInfo = [infoDic objectForKey:language];
//            _kUIFirm.text = [NSString stringWithFormat:@"  %@%@", DPLocalizedString(@"firm_info", @"   厂商："), [productInfo objectForKey:@"name"]];
//            _kUITel.text = [NSString stringWithFormat:@"  %@%@", DPLocalizedString(@"firm_tel", @"   电话号码："), [productInfo objectForKey:@"phone"]];
//            _kUIAddress.text = [NSString stringWithFormat:@"  %@%@", DPLocalizedString(@"firm_address", @"   地址："), [productInfo objectForKey:@"address"]];
//            if (![VerifyUtil isEmpty:[infoDic objectForKey:@"logo_path"]]) {
//                [ImageUtil loadImgFromUrl:[GLOBAL_LOGO_PREF stringByAppendingString:[infoDic objectForKey:@"logo_path"]] imageView:_kLogo imageType:IMG_TYPE_LOGO];
//            } else {
//                _kLogo.image = [UIImage imageNamed:@"icon_device_sample"];
//            }
//        } else {
//            [self resetViewController];
//        }
//    }
    
}

/**
 *  将该界面的设备信息显示成与App相关的设备信息
 */
-(void)resetViewController {
    _kUIFirm.text = [NSString stringWithFormat:@"  %@%@", DPLocalizedString(@"firm_info", @"   厂商："), @""];
    _kUITel.text = [NSString stringWithFormat:@"  %@%@", DPLocalizedString(@"firm_tel", @"   电话号码："), @""];
    _kUIAddress.text = [NSString stringWithFormat:@"  %@%@", DPLocalizedString(@"firm_address", @"   地址："), @""];
    _kLogo.image = [UIImage imageNamed:@"icon_device_sample"];
}

@end
