//
//  ALPageControl.h
//  BusinessScale
//
//  Created by Alvin on 16/2/19.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ALPageControl : UIView

@property (nonatomic, assign) NSInteger numberOfPages;
@property (nonatomic, assign) NSInteger currentPage;

- (instancetype)initWithCounts:(NSInteger)count;

@end
