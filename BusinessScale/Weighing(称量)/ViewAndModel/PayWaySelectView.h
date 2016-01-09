//
//  PayWaySelectView.h
//  BusinessScale
//
//  Created by Alvin on 15/12/18.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayWaySelectView : UIView

@property (weak, nonatomic) IBOutlet UILabel *priceL; // 结算价
@property (weak, nonatomic) IBOutlet ALTextField *realPriceTextField; // 折扣价
@property (nonatomic, copy) void(^callBack) (PayWayType type);

+ (instancetype)loadXibView;
- (void)showAnimate:(BOOL)animate;
- (void)hide;
- (void)showSuccessQrImage:(NSString *)codeURL;

@end
