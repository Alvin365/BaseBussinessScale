//
//  GoodsAddView.m
//  BusinessScale
//
//  Created by Alvin on 15/12/19.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import "GoodsAddView.h"
#import "SelectImageOptionView.h"
#import "UIViewController+Category.h"
#import "GoodsListHttpTool.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

@interface GoodsAddView()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    BOOL _animate;
    UIImage *newHeaderImage;
    WeightUnit _currentUnit;
    GoodsTempList *_model;
}

@property (weak, nonatomic) IBOutlet UIView *backGroudView;
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

@end

@implementation GoodsAddView

- (void)awakeFromNib
{
    _currentUnit = WeightUnit_killoGram;
    [self initView];
    [self initConstraint];
    [self.backGroudView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)]];
}

- (void)initView
{
    self.backGroudView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    
    self.contentView.layer.cornerRadius = 10;
    self.contentView.layer.masksToBounds = YES;
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.goosList.dataSource = self;
    self.goosList.delegate = self;
    
    self.goods.backgroundColor = self.number.backgroundColor = self.price.backgroundColor = [UIColor colorWithHexString:@"f3f3f3"];
    
    self.goodsFlag.textColor = self.numberFlag.textColor = self.priceFlag.textColor = [UIColor colorWithHexString:@"9f9f9f"];
    self.nameTextField.inputField.textColor = self.numberTextField.inputField.textColor = self.priceTextField.inputField.textColor = ALTextColor;
    self.nameTextField.inputField.keyboardType = UIKeyboardTypeDefault;
    self.numberTextField.inputField.keyboardType = UIKeyboardTypeNumberPad;
    self.priceTextField.inputField.keyboardType = UIKeyboardTypeDecimalPad;
    self.nameTextField.backgroundColor = self.numberTextField.backgroundColor = self.priceTextField.backgroundColor = [UIColor clearColor];
//    self.priceTextField.inputField.textAlignment = NSTextAlignmentRight;
    
    self.unitFirstBtn.backgroundColor = [UIColor colorWithHexString:@"9a9a9a"];
    self.unitSecondBtn.backgroundColor = [UIColor whiteColor];
    self.unitSecondBtn.layer.borderColor = [UIColor colorWithHexString:@"9a9a9a"].CGColor;
    self.unitSecondBtn.layer.borderWidth = 0.7;
    [self.unitSecondBtn setTitleColor:[UIColor colorWithHexString:@"9a9a9a"] forState:UIControlStateNormal];
    [self.unitSecondBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] andSize:self.unitSecondBtn.size] forState:UIControlStateNormal];
    [self.unitSecondBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"9a9a9a"] andSize:self.unitSecondBtn.size] forState:UIControlStateHighlighted];
//    self.unitThirdBtn.backgroundColor = [UIColor colorWithHexString:@"9a9a9a"];
    self.unitThirdBtn.backgroundColor = [UIColor whiteColor];
    self.unitThirdBtn.layer.borderColor = [UIColor colorWithHexString:@"9a9a9a"].CGColor;
    self.unitThirdBtn.layer.borderWidth = 0.7;
    [self.unitThirdBtn setTitleColor:[UIColor colorWithHexString:@"9a9a9a"] forState:UIControlStateNormal];
    [self.unitThirdBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] andSize:self.unitThirdBtn.size] forState:UIControlStateNormal];
    [self.unitThirdBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"9a9a9a"] andSize:self.unitThirdBtn.size] forState:UIControlStateHighlighted];
    
    self.unitFourthBtn.backgroundColor = [UIColor whiteColor];
    self.unitFourthBtn.layer.borderColor = [UIColor colorWithHexString:@"9a9a9a"].CGColor;
    self.unitFourthBtn.layer.borderWidth = 0.7;
    [self.unitFourthBtn setTitleColor:[UIColor colorWithHexString:@"9a9a9a"] forState:UIControlStateNormal];
    [self.unitFourthBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] andSize:self.unitFourthBtn.size] forState:UIControlStateNormal];
    [self.unitFourthBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"9a9a9a"] andSize:self.unitFourthBtn.size] forState:UIControlStateHighlighted];
    
    self.cancleButton.backgroundColor = [UIColor colorWithHexString:@"90bf46"];
    self.saveButton.backgroundColor = [UIColor colorWithHexString:@"7ca832"];
    
    /**
     * 头像点击事件
     */
    self.goodsImage.userInteractionEnabled = YES;
    [self.goodsImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photo)]];
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
    self.unitButtonWidth.constant = 110*ALScreenScalWidth;
}

- (IBAction)btnClick:(UIButton *)sender
{
    if (sender.tag>=1001) {
        if (sender.tag == 1002) {
//            if (self.numberTextField.inputField.text.length>4) {
//                [MBProgressHUD showMessage:@"编号不能超过4位"];
//                return;
//            }
            if ([self juddgeEmpty]) {
                return;
            }
            if ([self.priceTextField.inputField.text floatValue]==0.0f) {
                [MBProgressHUD showMessage:@"单价不能为0"];
                return;
            }
            if (self.callBack) {
                self.callBack(self.model,NO);
            }
        }else{
            if (self.callBack) {
                self.callBack(self.model,YES);
            }
            [self hideAnimate:YES];
        }
    }else{
        self.unitSecondBtn.hidden = self.unitThirdBtn.hidden = self.unitFourthBtn.hidden = !self.unitSecondBtn.hidden;
        WeightUnit tag = self.unitFirstBtn.tag;
        WeightUnit exChangeTag = sender.tag;
        self.unitFirstBtn.tag = exChangeTag;
        [self.unitFirstBtn setTitle:[NSString stringWithFormat:@"元/%@",[UnitTool stringFromWeight:exChangeTag]] forState:UIControlStateNormal];
        sender.tag = tag;
        [sender setTitle:[NSString stringWithFormat:@"元/%@",[UnitTool stringFromWeight:tag]] forState:UIControlStateNormal];
    }
}

- (WeightUnit)currentUnit
{
    return (WeightUnit)self.unitFirstBtn.tag;
}

- (void)setCurrentUnit:(WeightUnit)currentUnit
{
    _currentUnit = currentUnit;
    UIButton *btn = (UIButton *)([self viewWithTag:currentUnit]);
    [self btnClick:btn];
    self.unitSecondBtn.hidden = self.unitThirdBtn.hidden = self.unitFourthBtn.hidden = YES;
    
    [self.unitFirstBtn setNeedsLayout];
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

- (void)hideAnimate:(BOOL)animate
{
    self.unitSecondBtn.hidden = self.unitThirdBtn.hidden = self.unitFourthBtn.hidden = YES;
    self.goosList.hidden = YES;
    if (!animate) {
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
    [self hideAnimate:YES];
    [self initilize];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellInden = @"cell";
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellInden];
    if (!cell) {
        cell = [[BaseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellInden];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.backgroundColor = [UIColor lightGrayColor];
    }
    if (indexPath.row < _dataSource.count) {
        cell.sepT.hidden = indexPath.row;
        cell.textLabel.text = [[(NSDictionary *)_dataSource[indexPath.row] allKeys] lastObject];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    self.nameTextField.inputField.text = [[(NSDictionary *)_dataSource[indexPath.row] allKeys] lastObject];
    NSString *image = [[(NSDictionary *)_dataSource[indexPath.row] allValues] lastObject];
    [self.goodsImage setImageWithIcon:image];
    _icon = image;
    self.goosList.hidden = YES;
    [self endEditing:YES];
}

- (void)setDataSource:(NSArray *)dataSource
{
    _dataSource = dataSource;
    self.goosList.hidden = !(_dataSource.count);
    [self.goosList reloadData];
}

- (void)initilize
{
    self.goodsImage.image = [UIImage imageNamed:@"default"];
    self.nameTextField.inputField.text = nil;
    self.numberTextField.inputField.text = nil;
    self.priceTextField.inputField.text = nil;
}

- (BOOL)juddgeEmpty
{
    BOOL b = NO;
    if (!self.goodsImage.image) {
        [MBProgressHUD showError:@"头像不能为空"];
        return YES;
    }
    NSString *string = self.nameTextField.inputField.text;
    if (!string.length) {
        [MBProgressHUD showError:@"名称不能为空"];
        return YES;
    }
    string = self.numberTextField.inputField.text;
    if (!string.length) {
        [MBProgressHUD showError:@"编号不能为空"];
        return YES;
    }
    string = self.priceTextField.inputField.text;
    if (!string.length) {
        [MBProgressHUD showError:@"价格不能为空"];
        return YES;
    }
    return b;
}
#pragma mark -photo
- (void)photo
{
    SelectImageOptionView *select = [[SelectImageOptionView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    select.callBtnBack = ^(selectBtnTag tag){
        if (tag == selectBtnTagCamera) {
            [self camera];
        }else{
            [self abm];
        }
    };
    [select showFromBottom];
}
// 拍照
- (void)camera
{
    void (^allowBlock)() = ^{
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        if (iOS8) {
            imagePicker.modalPresentationStyle = UIModalPresentationCurrentContext;
        }
        UIViewController *ctl = [[[UIApplication sharedApplication] windows]lastObject].rootViewController;
        [ctl presentViewController:imagePicker animated:YES completion:nil];
    };
    NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
    if (authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (granted) {
                    //第一次用户接受
                    allowBlock();
                }else{
                    //用户拒绝
                    showAlert(@"已拒绝授权，打开相机失败");
                }
            });
        }];
        return;
    }else if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        showAlert(@"相机权限受限,请在设置中启用");
        return;
    }
    allowBlock();
}
// 相册
- (void)abm
{
    void (^allowEvent)() = ^{
        UIImagePickerControllerSourceType sourceType;
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.sourceType = sourceType;
        picker.allowsEditing = YES;
        UIViewController *ctl = [[[UIApplication sharedApplication] windows]lastObject].rootViewController;
        [ctl presentViewController:picker animated:YES completion:nil];
    };
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        PHAuthorizationStatus author = [PHPhotoLibrary authorizationStatus];
        if (author == PHAuthorizationStatusNotDetermined) {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (status == PHAuthorizationStatusAuthorized) {
                        allowEvent();
                    }else{
                        showAlert(@"用户取消相册授权,请在设置中启用");
                    }
                });
            }];
            return;
        }else if(author == PHAuthorizationStatusRestricted || author == PHAuthorizationStatusDenied){
            showAlert(@"相册权限受限,请在设置中启用");
            return;
        }
        allowEvent();
    }
}

#pragma mark - PhotoDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
        if ([type isEqualToString:@"public.image"])
        {
            // 判断，图片是否允许修改
            if ([picker allowsEditing]) {
                newHeaderImage = [info objectForKey:UIImagePickerControllerEditedImage];
            } else {
                newHeaderImage = [info objectForKey:UIImagePickerControllerOriginalImage];
            }
            if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
                
                UIImageWriteToSavedPhotosAlbum(newHeaderImage, nil, nil, nil);
            }
            newHeaderImage = [newHeaderImage fixOrientation];
            //保持图片方向
        }
        NSData *imageData = nil;
        imageData = UIImageJPEGRepresentation(newHeaderImage, 0);
        dispatch_async(dispatch_get_main_queue(), ^{
            _icon = @"default";
            [self upLoadImageWithData:newHeaderImage];
        });
    });
    
}

- (void)upLoadImageWithData:(UIImage *)image
{
    [self.progressHud show:YES];
    GoodsListHttpTool *req = [[GoodsListHttpTool alloc]initWithParam:[GoodsListHttpTool upLoadWithImage:image]];
    [req setReturnBlock:^(NSURLSessionTask *task, NSURLResponse *response, id responseObject) {
        [self doDatasFromNet:responseObject useFulData:^(NSObject *data) {
            if (data) {
                self.goodsImage.image = image;
                _icon = (NSString *)data;
            }
        }];
        ALLog(@"%@",responseObject);
    }];
}

- (void)setModel:(GoodsTempList *)model
{
    _model = model;
    [self.goodsImage setImageWithIcon:_model.icon];
    _icon = model.icon;
    self.nameTextField.inputField.text = _model.title;
    if (model.number) {
        self.numberTextField.inputField.text = [NSString stringWithFormat:@"%d",(int)_model.number];
    }
    
    if (model.unit_price) {
        self.priceTextField.inputField.text = [NSString stringWithFormat:@"%g",_model.unit_price/100.0f];
    }
    
    if (model.unit) {
        self.currentUnit = _model.unit;
    }
}

- (GoodsTempList *)model
{
    if (!_model) {
        _model = [[GoodsTempList alloc]init];
    }
    _model.icon = self.icon;
    _model.title = self.nameTextField.inputField.text;
    NSString *number = [NSString stringWithFormat:@"%04d",(int)[self.numberTextField.inputField.text integerValue]];
    _model.number = [number integerValue];
    
    _model.unit_price = [self.priceTextField.inputField.text floatValue]*100;
    _model.unit = self.currentUnit;
    _model.mac = [ScaleTool scale].mac;
    _model.uid = [AccountTool account].ID;
    return _model;
}

@end
