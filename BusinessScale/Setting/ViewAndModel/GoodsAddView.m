//
//  GoodsAddView.m
//  BusinessScale
//
//  Created by Alvin on 15/12/19.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import "GoodsAddView.h"

@interface GoodsAddView()<UITextFieldDelegate>
{
    BOOL _animate;
}

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIView *goods;
@property (weak, nonatomic) IBOutlet UIView *number;
@property (weak, nonatomic) IBOutlet UIView *price;

@property (weak, nonatomic) IBOutlet UILabel *goodsFlag;
@property (weak, nonatomic) IBOutlet UILabel *numberFlag;
@property (weak, nonatomic) IBOutlet UILabel *priceFlag;
@property (weak, nonatomic) IBOutlet UIButton *unitFirstBtn;
@property (weak, nonatomic) IBOutlet UIButton *unitSecondBtn;
@property (weak, nonatomic) IBOutlet UIButton *unitThirdBtn;
@property (weak, nonatomic) IBOutlet UIButton *unitFourthBtn;

@property (weak, nonatomic) IBOutlet UIButton *cancleButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewRight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imagWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodsLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodsTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodsHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *unitButtonWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancleButtonHeight;

@property (nonatomic, strong) NSDictionary *keysValues;

@end

@implementation GoodsAddView

- (NSDictionary *)keysValues
{
    if (!_keysValues) {
        _keysValues = @{@(GoodsAddViewButtonTagUnitKiloGram):@"公斤",@(GoodsAddViewButtonTagUnit500Gram):@"斤",@(GoodsAddViewButtonTagUnit50Gram):@"两",@(GoodsAddViewButtonTagUnitGram):@"克"};
    }
    return _keysValues;
}

- (void)awakeFromNib
{
    [self initView];
    [self initConstraint];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)]];
}

- (void)initView
{
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    
    self.contentView.layer.cornerRadius = 10;
    self.contentView.layer.masksToBounds = YES;
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.goods.backgroundColor = self.number.backgroundColor = self.price.backgroundColor = [UIColor colorWithHexString:@"f3f3f3"];
    
    self.goodsFlag.textColor = self.numberFlag.textColor = self.priceFlag.textColor = [UIColor colorWithHexString:@"9f9f9f"];
    self.nameTextField.inputField.textColor = self.numberTextField.inputField.textColor = self.priceTextField.inputField.textColor = ALTextColor;
    self.nameTextField.inputField.keyboardType = UIKeyboardTypeDefault;
    self.numberTextField.inputField.keyboardType = UIKeyboardTypeNumberPad;
    self.priceTextField.inputField.keyboardType = UIKeyboardTypeDecimalPad;
    self.nameTextField.backgroundColor = self.numberTextField.backgroundColor = self.priceTextField.backgroundColor = [UIColor clearColor];
    self.priceTextField.inputField.textAlignment = NSTextAlignmentRight;
    
    self.unitFirstBtn.backgroundColor = [UIColor colorWithHexString:@"9a9a9a"];
    self.unitSecondBtn.backgroundColor = [UIColor whiteColor];
    self.unitSecondBtn.layer.borderColor = [UIColor colorWithHexString:@"9a9a9a"].CGColor;
    self.unitSecondBtn.layer.borderWidth = 0.7;
    [self.unitSecondBtn setTitleColor:[UIColor colorWithHexString:@"9a9a9a"] forState:UIControlStateNormal];
    self.unitThirdBtn.backgroundColor = [UIColor colorWithHexString:@"9a9a9a"];
    self.unitFourthBtn.backgroundColor = [UIColor whiteColor];
    self.unitFourthBtn.layer.borderColor = [UIColor colorWithHexString:@"9a9a9a"].CGColor;
    self.unitFourthBtn.layer.borderWidth = 0.7;
    [self.unitFourthBtn setTitleColor:[UIColor colorWithHexString:@"9a9a9a"] forState:UIControlStateNormal];
    
    self.cancleButton.backgroundColor = [UIColor colorWithHexString:@"90bf46"];
    self.saveButton.backgroundColor = [UIColor colorWithHexString:@"7ca832"];
}

- (void)initConstraint
{
    self.contentViewLeft.constant = self.contentViewRight.constant = 15*ALScreenScalWidth;
    self.contentViewTop.constant = self.contentViewBottom.constant = 107*ALScreenScalHeight;
    self.imageTop.constant = 25*ALScreenScalHeight;
    self.imagWidth.constant = self.imageHeight.constant = 125*ALScreenScalHeight;
    self.goodsImage.layer.cornerRadius = self.imagWidth.constant/2.0f;
    self.goodsImage.layer.masksToBounds = YES;
    
    self.goodsTop.constant = 30*ALScreenScalHeight;
    self.goodsHeight.constant = 50*ALScreenScalHeight;
    
    self.cancleButtonHeight.constant = 60*ALScreenScalHeight;
    self.unitButtonWidth.constant = 100*ALScreenScalWidth;
}

- (IBAction)btnClick:(UIButton *)sender
{
    if (sender.tag<GoodsAddViewButtonTagUnitKiloGram) {
        [self hide];
        if (self.callBack) {
            self.callBack((GoodsAddViewButtonTag)sender.tag);
        }
    }else{
        self.unitSecondBtn.hidden = self.unitThirdBtn.hidden = self.unitFourthBtn.hidden = !self.unitSecondBtn.hidden;
        GoodsAddViewButtonTag tag = self.unitFirstBtn.tag;
        GoodsAddViewButtonTag exChangeTag = sender.tag;
        self.unitFirstBtn.tag = exChangeTag;
        [self.unitFirstBtn setTitle:self.keysValues[@(exChangeTag)] forState:UIControlStateNormal];
        sender.tag = tag;
        [sender setTitle:self.keysValues[@(tag)] forState:UIControlStateNormal];
    }
}

#pragma mark -Method
+ (instancetype)loadXibView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"GoodsAddView" owner:nil options:nil] firstObject];
}

- (void)showAnimate:(BOOL)animate
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    _animate = animate;
    if (!animate) {
        return;
    }
    [_contentView.layer layerZoomIn];
}

- (void)hide
{
    self.unitSecondBtn.hidden = self.unitThirdBtn.hidden = self.unitFourthBtn.hidden = YES;
    if (!_animate) {
        [self removeFromSuperview];
        return;
    }
    [_contentView.layer layerZoomOut];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}

- (void)tap
{
    [self endEditing:YES];
}

@end
