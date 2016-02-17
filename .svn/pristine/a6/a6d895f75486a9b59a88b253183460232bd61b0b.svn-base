//
//  SetPinningController.m
//  BusinessScale
//
//  Created by Alvin on 16/1/28.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import "SetPinningController.h"
#import <Commercial-Bluetooth/CsBtUtil.h>
@interface SetPinningController ()
@property (weak, nonatomic) IBOutlet UITextField *pinText;

@end

@implementation SetPinningController

- (void)viewDidLoad {
    [super viewDidLoad];
    _pinText.text = [CsBtCommon getPin];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnClick:(id)sender {
    [CsBtCommon setPin:_pinText.text];
    if (self.isPush) {
        [self.navigationController pushViewController:[[NSClassFromString(@"BoundDeviceController") alloc]init] animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
