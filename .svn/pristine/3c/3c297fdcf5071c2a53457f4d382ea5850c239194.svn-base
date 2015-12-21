//
//  ALWellComeView.m
//  BusinessScaleBase
//
//  Created by Alvin on 15/12/15.
//  Copyright © 2015年 chipsea. All rights reserved.
//

#import "ALWellComeView.h"
#import "UIView+Extension.h"
#define imageCounts 4

@interface ALWellComeView()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *page;

@end

@implementation ALWellComeView

- (instancetype)init
{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(screenWidth*imageCounts, screenHeight);
    _scrollView.bounces = NO;
    [self addSubview:_scrollView];
    
    _page = [[UIPageControl alloc]initWithFrame:CGRectMake(0, screenHeight-30, screenWidth, 20)];
    _page.alpha = 0.5;
    _page.numberOfPages = imageCounts;
    _page.currentPage = 0;
    _page.currentPageIndicatorTintColor = [UIColor redColor];
    _page.pageIndicatorTintColor = [UIColor whiteColor];
    [self addSubview:_page];
    
    for (int i = 0; i<imageCounts; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        imageView.x = i*screenWidth;
        [_scrollView addSubview:imageView];
    }
    
}

- (void)show
{
    [[[UIApplication sharedApplication] windows].lastObject addSubview:self];
}

- (void)hide
{
    [self removeFromSuperview];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _page.currentPage = scrollView.contentOffset.x/screenWidth;
}

@end
