//
//  QrCodeViewController.m
//  BusinessScale
//
//  Created by Alvin on 16/1/5.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import "QrCodeViewController.h"
#import <ZXMultiFormatWriter.h>
#import <ZXImage.h>
@interface QrCodeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *qrImageView;

@end

@implementation QrCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialize];
}

- (void)initialize
{
    ZXMultiFormatWriter *writer = [[ZXMultiFormatWriter alloc] init];
    ZXBitMatrix *result = [writer encode:_codeURL
                                  format:kBarcodeFormatQRCode
                                   width:self.qrImageView.frame.size.width
                                  height:self.qrImageView.frame.size.height
                                   error:nil];
    if (result) {
        ZXImage *image = [ZXImage imageWithMatrix:result];
        self.qrImageView.image = [UIImage imageWithCGImage:image.cgimage];
    } else {
        self.qrImageView.image = nil;
    }
}

@end
