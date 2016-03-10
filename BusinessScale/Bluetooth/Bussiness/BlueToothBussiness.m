//
//  BlueToothBussiness.m
//  BusinessScale
//
//  Created by Alvin on 16/3/8.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import "BlueToothBussiness.h"
#import <Commercial-Bluetooth/CsBtUtil.h>
@implementation BlueToothBussiness

+ (void)removeBoundToBleUpdateSychroLogoCompletedBlock:(void(^)())block
{
    [[GoodsTempList getUsingLKDBHelper]search:[GoodsTempList class] where:nil orderBy:nil offset:0 count:0 callback:^(NSMutableArray *array) {
        for (GoodsTempList *temp in array) {
            temp.isSychro = 0;
            [temp updateToDB];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [LocalDataTool removeDocumAtPath:@"scale.data"];
            [[CsBtUtil getInstance] disconnectWithBt];
            [CsBtCommon clearBoundMac];
            [[CsBtUtil getInstance]stopScanBluetoothDevice];
            if (block) {
                block();
            }
        });
    }];
}

@end
