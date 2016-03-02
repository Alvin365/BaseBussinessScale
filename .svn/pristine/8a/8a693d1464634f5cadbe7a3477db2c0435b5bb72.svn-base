//
//  UIInputTextField.m
//  btWeigh
//
//  Created by mac on 15-1-4.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "UIInputTextField.h"


@implementation UIInputTextField

/*
    从写这个函数，xib初始化的时候
    会调用这个函数初始化 
    在这里初始化的init的变量对象，全局可用！！
 */
- (id)initWithCoder:(NSCoder*)coder{
    self = [super initWithCoder:coder];
    if (self) {
        // Initialization code
        /*
         1. 设置del删除图片和按钮
         */
        UIImage *image = [UIImage imageNamed:(@"view_input_del.png")];
        
        CGFloat delViewWidth = self.bounds.size.width/13;
        CGFloat delViewHeight = self.bounds.size.height/2;
        
        CGFloat delViewX = self.bounds.size.width - delViewWidth - delViewWidth/5;
        CGFloat delViewY = self.bounds.size.height/2 - delViewHeight/2;
        
        
        _delView = [[UIImageView alloc]initWithFrame:CGRectMake(delViewX,delViewY, delViewWidth ,delViewHeight)];
        
        //设置UIImageView的显示图片模式
        _delView.contentMode = UIViewContentModeScaleAspectFit;
        
        [_delView setImage:image];
        
        _delView.hidden = YES;
        
        _delView.userInteractionEnabled = YES;//allow click！！
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(delClick)];
        
        [_delView addGestureRecognizer:(singleTap)];
        
        /*
         2. 设置输入的按钮
         */
        //textField全屏布局满整个View
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width,self.bounds.size.height)];
        
//        UIImage *imageTextField = [UIImage imageNamed:(@"view_inputs_bg.png")];
//        
//        [_textField setBackground:imageTextField];
        
        //必须要设置了Placeholder才可以通过下面的来设置某某
        [_textField setPlaceholder:@"请输入内容"];
        [_textField setValue:[UIFont boldSystemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
        
        //对textField添加监听时间,当文字修改的时候会回调textFieldDidchange!
        [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        /*
         3. 添加到当前的View中
         */
        [self addSubview:_textField];
        [self addSubview:_delView];
    }
    return self;
}

#pragma Click 回调函数
/*
    @author kenneth
    Want you click the view will clear
    the _textField 's content.
 */
-(void)delClick{
    [_textField setText:(@"")];
    _delView.hidden = YES;
}


/*  
    @author kenneth
    实现textField回调函数
*/
- (void) textFieldDidChange:(id) sender {
    _delView.hidden = NO;
}


/*
    @author kenneth
    获得当前的TextField!
 */
-(UITextField *)getUITextField{
    return self.textField;
}

-(void)setPlaceholder:(NSString *)hint{

    [self.textField setPlaceholder:hint];
}

-(NSString *)getPlaceholder{
    return self.textField.placeholder;
}
@end
