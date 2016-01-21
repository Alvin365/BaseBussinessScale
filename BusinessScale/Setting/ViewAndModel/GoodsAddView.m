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

@interface GoodsAddView()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    BOOL _animate;
    UIImage *newHeaderImage;
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
    self.currentUnit = WeightUnit_killoGram;
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
//    self.goodsImage.userInteractionEnabled = YES;
//    [self.goodsImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photo)]];
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
        [self hideAnimate:YES];
        if (![self juddgeEmpty]) {
            if (self.callBack) {
                self.callBack(sender.tag);
            }
        }else{
            if (sender.tag == 1002) {
               [MBProgressHUD showMessage:@"请填写完整信息和菜品头像"];
            }
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
    image = [[image componentsSeparatedByString:@"/"] lastObject];
    self.goodsImage.image = [UIImage imageNamed:image];
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
    self.goodsImage.image = nil;
    self.nameTextField.inputField.text = nil;
    self.numberTextField.inputField.text = nil;
    self.priceTextField.inputField.text = nil;
}

- (BOOL)juddgeEmpty
{
    return !(self.goodsImage.image&&self.nameTextField.inputField.text&&self.numberTextField.inputField.text&&self.priceTextField.inputField.text);
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

- (void)camera
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    if (iOS8) {
        imagePicker.modalPresentationStyle = UIModalPresentationCurrentContext;
    }
    UIViewController *ctl = [[[UIApplication sharedApplication] windows]lastObject].rootViewController;
    [ctl presentViewController:imagePicker animated:YES completion:nil];
}
- (void)abm
{
    UIImagePickerControllerSourceType sourceType;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.sourceType = sourceType;
        picker.allowsEditing = YES;
         UIViewController *ctl = [[[UIApplication sharedApplication] windows]lastObject].rootViewController;
        [ctl presentViewController:picker animated:YES completion:nil];
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
            [self upLoadImageWithData:newHeaderImage];
        });
    });
    
}

- (void)upLoadImageWithData:(UIImage *)image
{
    GoodsListHttpTool *req = [[GoodsListHttpTool alloc]initWithParam:[GoodsListHttpTool upLoadWithImage:image]];
    [req setReturnBlock:^(NSURLSessionTask *task, NSURLResponse *response, id responseObject) {
        ALLog(@"%@",responseObject);
    }];
}

@end
