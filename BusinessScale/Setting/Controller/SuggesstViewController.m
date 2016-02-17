//
//  SuggesstViewController.m
//  BusinessScale
//
//  Created by Alvin on 16/1/20.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import "SuggesstViewController.h"
#import "SettingRequestTool.h"
#import "ALKeyBordTool.h"
@interface SuggesstViewController ()<UITextViewDelegate>
{
    BOOL canPublic;
}
@property (nonatomic, weak) UITextView *textView;
@property (nonatomic, strong) UILabel *placeHolder;
@property (nonatomic, weak) UIButton *btn;

@end

@implementation SuggesstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildTextView];
    self.view.backgroundColor = backGroudColor;
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)]];
}

- (void)buildTextView
{
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(20,20, screenWidth-40, 200)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange:) name:UITextViewTextDidChangeNotification object:nil];
    textView.delegate = self;
    textView.layer.cornerRadius = 3;
    textView.textColor = ALTextColor;
    textView.font = [UIFont systemFontOfSize:13];
    textView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:textView];
    self.textView = textView;
    
    ALKeyBordTool *keyBoarTool = [ALKeyBordTool loadXibView];
    keyBoarTool.frame = CGRectMake(0, 0, screenWidth, 40);
    keyBoarTool.callBack = ^(NSInteger index){
        [self.view endEditing:YES];
    };
    textView.inputAccessoryView = keyBoarTool;
    
    _placeHolder = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, textView.width-10, 20)];
    _placeHolder.text = @"亲，您遇到什么问题或功能建议，欢迎反馈给我们，谢谢";
    _placeHolder.height = [_placeHolder.text bundingWithSize:CGSizeMake(_placeHolder.width, 2000) Font:13].height;
    _placeHolder.textColor = ALLightTextColor;
    _placeHolder.numberOfLines = 0;
    _placeHolder.font = [UIFont systemFontOfSize:13];
    [textView addSubview:_placeHolder];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(textView.x, textView.y+textView.height+30, textView.width, 60);
    btn.backgroundColor = ALDisAbleColor;
    btn.layer.cornerRadius = 3;
    [btn setTitle:@"发送" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    canPublic = NO;
    self.btn = btn;
}

- (void)rightClick
{
    if (canPublic) {
        [self adViceShowWithContent:self.textView.text];
    }else{
        [MBProgressHUD showError:@"建议内容不能为空哦"];
    }
}

#pragma mark - NetRequest
- (void)adViceShowWithContent:(NSString *)content
{
    [self.progressHud show:YES];
    SettingRequestTool *req = [[SettingRequestTool alloc]initWithParam:[SettingRequestTool feedbackWithContent:content]];
    [req setReturnBlock:^(NSURLSessionTask *task, NSURLResponse *response, id responseObject) {
        [self doDatasFromNet:responseObject useFulData:^(NSObject *data) {
            if (data) {
                [MBProgressHUD showSuccess:@"感谢您的宝贵建议~" compleBlock:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }
        }];
    }];
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([NSString stringContainsEmoji:text]) {
        [MBProgressHUD show:@"非法字符" icon:nil view:nil compleBlock:nil];
        return NO;
    }
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [textView resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    return YES;
}

- (void)textChange:(NSNotification *)notice
{
    UITextView *textV = notice.object;
    
    canPublic = textV.text.length;
    _placeHolder.hidden = textV.text.length;
    if (canPublic) {
        self.btn.backgroundColor = ALNavBarColor;
    }else{
        self.btn.backgroundColor = ALDisAbleColor;
    }
}

- (void)textFieldChanged:(NSNotification *)notice
{
    UITextField *textField = notice.object;
    if ([ALCommonTool hasillegalString:textField.text]) {
        [MBProgressHUD showError:@"非法字符"];
    }
}

- (void)tap
{
    [self.view endEditing:YES];
}


@end
