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
    _scrollView.contentOffset = CGPointMake(0, 0);
    _scrollView.delegate = self;
    _scrollView.bounces = NO;
    _scrollView.userInteractionEnabled = YES;
    [self addSubview:_scrollView];
    
    _page = [[UIPageControl alloc]initWithFrame:CGRectMake(0, screenHeight-30, screenWidth, 20)];
    _page.alpha = 0.8;
    _page.numberOfPages = imageCounts;
    _page.currentPage = 0;
    _page.currentPageIndicatorTintColor = ALNavBarColor;
    _page.pageIndicatorTintColor = [UIColor grayColor];
    [self addSubview:_page];
    for (int i = 0; i<imageCounts; i++) {
        NSString *imageName = [NSString stringWithFormat:@"引导页-0%i",i+1];
        if (screenHeight==480) {
            [imageName stringByAppendingString:@"_4s"];
        }
        [imageName stringByAppendingString:@".png"];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        imageView.userInteractionEnabled = YES;
        imageView.x = i*screenWidth;
        imageView.image = [UIImage imageNamed:imageName];
        [_scrollView addSubview:imageView];
        if (i==(imageCounts-1)) {
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)]];
        }
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
