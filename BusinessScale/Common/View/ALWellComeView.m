//
//  ALWellComeView.m
//  BusinessScaleBase
//
//  Created by Alvin on 15/12/15.
//  Copyright © 2015年 chipsea. All rights reserved.
//

#import "ALWellComeView.h"
#import "UIView+Extension.h"
#import "ALPageControl.h"
#define imageCounts 4

@interface ALWellComeView()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) ALPageControl *page;

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
    
    _page = [[ALPageControl alloc]initWithCounts:imageCounts];
    _page.frame = CGRectMake(0, screenHeight-30, screenWidth, 20);
    
//    _page.hidesForSinglePage = YES;
//    [_page setValue:[UIImage imageWithColor:ALNavBarColor andSize:CGSizeMake(30, 10)] forKeyPath:@"_currentPageImage"];
//    [_page setValue:[UIImage imageWithColor:[UIColor grayColor] andSize:CGSizeMake(10, 10)] forKeyPath:@"_pageImage"];
    
    _page.alpha = 0.8;
//    _page.numberOfPages = imageCounts;
//    _page.currentPage = 0;
//    _page.currentPageIndicatorTintColor = ALNavBarColor;
//    _page.pageIndicatorTintColor = [UIColor grayColor];
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
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(imageView.width/2.0f-75, imageView.height-100, 150, 50);
            [btn setTitle:@"立即体验" forState:UIControlStateNormal];
            [btn setTitleColor:ALNavBarColor forState:UIControlStateNormal];
            btn.layer.borderWidth = 1;
            btn.layer.borderColor = ALNavBarColor.CGColor;
            btn.layer.cornerRadius = 15;
            btn.layer.masksToBounds = YES;
            [btn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:btn];
//            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)]];
        }
    }
    
}

- (void)show
{
    [[[UIApplication sharedApplication] windows].lastObject addSubview:self];
}

- (void)hide
{
    [UIView animateWithDuration:1.0f animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _page.currentPage = scrollView.contentOffset.x/screenWidth;
}

@end
