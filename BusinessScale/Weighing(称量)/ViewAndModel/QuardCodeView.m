//
//  QuardCodeView.m
//  BusinessScale
//
//  Created by Alvin on 16/1/26.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import "QuardCodeView.h"
#import <ZXMultiFormatWriter.h>
#import <ZXImage.h>
@interface QuardCodeView()
{
    BOOL _animate;
}

@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UILabel *plsScanL;
@property (weak, nonatomic) IBOutlet UILabel *plsScanWeixin;
@property (weak, nonatomic) IBOutlet UIImageView *qrCodeImageView;

@property (nonatomic, weak) IBOutlet UIImageView *qrCodeImageView_Second;
@property (nonatomic, strong) UIButton *widthBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondImageTop;


@end

@implementation QuardCodeView

- (void)awakeFromNib
{
    [self initUIFromXib];
    [self initConstraint];
//    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)]];
}

- (void)initUIFromXib
{
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    
    _priceL.textColor = [UIColor whiteColor];
    _priceL.backgroundColor = [UIColor clearColor];
    
    _qrCodeImageView.backgroundColor = backGroudColor;
    _qrCodeImageView_Second.backgroundColor = backGroudColor;
    _plsScanL.textColor = [UIColor whiteColor];
    _plsScanWeixin.textColor = [UIColor whiteColor];
    
    
//    _widthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_widthBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_widthBtn];
}

- (void)initConstraint
{
    _priceTop.constant = 60.0f*ALScreenScalHeight;
    _imageWidth.constant = 210.0f*ALScreenScalHeight;
    _imageHeight.constant = 210.0f*ALScreenScalHeight;
    _secondImageTop.constant = 25.0f*ALScreenScalHeight;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _widthBtn.frame = CGRectMake(_btn.x-10, _btn.y-10, _btn.width+20, _btn.height+20);
}
#pragma mark - -methods
+ (instancetype)loadXibView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"QuardCodeView" owner:nil options:nil] firstObject];
}

- (void)showAnimate:(BOOL)animate
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    _animate = animate;
    if (!animate) {
        return;
    }
    [self.layer layerZoomIn];
}

- (void)hide
{
    if (!_animate) {
        [self removeFromSuperview];
        return;
    }
    [self.layer layerZoomOut];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}

- (void)showCodeWithCodeURLs:(NSArray *)array
{
    NSString *codeURL = array[0];
    ZXMultiFormatWriter *writer = [[ZXMultiFormatWriter alloc] init];
    ZXBitMatrix *result = [writer encode:codeURL
                                  format:kBarcodeFormatQRCode
                                   width:self.qrCodeImageView.frame.size.width
                                  height:self.qrCodeImageView.frame.size.height
                                   error:nil];
    if (result) {
        ZXImage *image = [ZXImage imageWithMatrix:result];
        self.qrCodeImageView.image = [UIImage imageWithCGImage:image.cgimage];
    } else {
        self.qrCodeImageView.image = nil;
    }
    
    codeURL = array[1];
    result = [writer encode:codeURL
                                  format:kBarcodeFormatQRCode
                                   width:self.qrCodeImageView_Second.frame.size.width
                                  height:self.qrCodeImageView_Second.frame.size.height
                                   error:nil];
    if (result) {
        ZXImage *image = [ZXImage imageWithMatrix:result];
        self.qrCodeImageView_Second.image = [UIImage imageWithCGImage:image.cgimage];
    } else {
        self.qrCodeImageView_Second.image = nil;
    }
    
    [self showAnimate:YES];
}

#pragma mark - -actions
//- (IBAction)btnClick:(id)sender {
//    [self hide];
//}

//- (void)tap
//{
//    [self btnClick:nil];
//}

@end
