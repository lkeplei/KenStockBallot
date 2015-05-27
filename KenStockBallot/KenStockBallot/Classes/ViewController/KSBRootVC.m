//
//  KSBRootVC.m
//  KenStockBallot
//
//  Created by ken on 15/5/27.
//  Copyright (c) 2015年 ken. All rights reserved.
//

#import "KSBRootVC.h"

@interface KSBRootVC ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation KSBRootVC

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = KenLocal(@"home_title");
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //scrollview
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kGSize.width, kGSize.height)];
    _scrollView.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    int pageIndex = 0;
    while (1) {
        NSString *name = [NSString stringWithFormat:@"%@%d.png", @"guide_page", pageIndex];
        UIImage *image = [UIImage imageNamed:name];
        if (image) {
            UIImageView *imgView = [[UIImageView alloc]initWithImage:image];
            if (kIPhone6) {
                float scale = kGSize.width / imgView.width;
                imgView.transform = CGAffineTransformMakeScale(scale, scale);
            }
            imgView.center = CGPointMake(pageIndex * kGSize.width + kGSize.width / 2, (kIPhone4 ? 45 : kGSize.height * 0.15) + imgView.height / 2);
            [_scrollView addSubview:imgView];
            
            pageIndex++;
        } else {
            break;
        }
    }
    
    _scrollView.contentSize  = CGSizeMake(pageIndex * kGSize.width, kGSize.height);
    _scrollView.contentOffset  = CGPointMake(0, 0);
    
    //pagecontrol
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    _pageControl.center = CGPointMake(self.view.center.x, self.view.center.y);
    _pageControl.currentPage = 0;
    _pageControl.numberOfPages = pageIndex;
    [self.view addSubview:_pageControl];
}

#pragma mark - pagecontrol
- (void)changePage:(id)sender {
    //根据pagecontroll的值来改变scrollview的滚动位置，以此切换到指定的页面
    [_scrollView setContentOffset:CGPointMake(self.view.width * _pageControl.currentPage, 0)];
}

#pragma mark - scroll
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    int x = aScrollView.contentOffset.x;
    _pageControl.currentPage = x / self.view.width;
}

@end
