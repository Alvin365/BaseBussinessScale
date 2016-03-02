//
//  ALPageControl.m
//  BusinessScale
//
//  Created by Alvin on 16/2/19.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import "ALPageControl.h"

@interface ALPageControl()

@property (nonatomic, strong) UIView *currentPageView;
@property (nonatomic, strong) NSMutableArray *subViewsSet;

@end

@implementation ALPageControl

//- (instancetype)initWithFrame:(CGRect)frame
//{
//    if (self = [super initWithFrame:frame]) {
//        [self initialize];
//    }
//    return self;
//}

- (instancetype)initWithCounts:(NSInteger)count
{
    if (self = [super init]) {
        _numberOfPages = count-1;
        [self initialize];
        self.alpha = 0.8;
    }
    return self;
}

- (void)initialize
{
    _subViewsSet = [NSMutableArray array];
    
    CGFloat beginX = (screenWidth-85.0f)/2.0f;
    _currentPageView = [[UIView alloc]initWithFrame:CGRectMake(beginX, 5, 30, 10)];
    _currentPageView.backgroundColor = ALNavBarColor;
    _currentPageView.layer.cornerRadius = 5;
    _currentPageView.layer.masksToBounds = YES;
    [_subViewsSet addObject:_currentPageView];
    _currentPageView.tag = 100;
    [self addSubview:_currentPageView];
    
    beginX += 35;
    for (NSInteger i = 0; i < _numberOfPages; i++) {
        UIView *indicatorView = [[UIView alloc]initWithFrame:CGRectMake(beginX, 5, 10, 10)];
        indicatorView.layer.cornerRadius = 5;
        indicatorView.layer.masksToBounds = YES;
        [self addSubview:indicatorView];
        indicatorView.backgroundColor = ALDisAbleColor;
        beginX += 17;
        [_subViewsSet addObject:indicatorView];
    }
}

- (void)setCurrentPage:(NSInteger)currentPage
{
    [_subViewsSet exchangeObjectAtIndex:_currentPage withObjectAtIndex:currentPage];
    _currentPage = currentPage;
//    CGFloat beginX = ((screenWidth-100)/2.0f)-5;
//    _currentPageView.x = beginX + 30*currentPage;
    [self layoutSubviews];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat beginX = (screenWidth-85.0f)/2.0f;
    CGFloat width = 0.0f;
    for (UIView *view in _subViewsSet) {
        if (view.tag == 100) {
            width = 30;
        }else{
            width = 10;
        }
        view.frame = CGRectMake(beginX, 5, width, 10);
        if (view.tag == 100) {
            beginX += width+5;
        }else{
            beginX += width+7;
        }
    }
}

@end
