//
//  KSBRootVC.m
//  KenStockBallot
//
//  Created by ken on 15/5/27.
//  Copyright (c) 2015年 ken. All rights reserved.
//

#import "KSBRootVC.h"
#import "KSBQuestionSelectVC.h"

@interface KSBRootVC ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation KSBRootVC

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = KenLocal(@"app_title");
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_bg.png"]];
    bgView.frame = (CGRect){CGPointZero, kGSize};
    [self.view addSubview:bgView];
    
    UIImageView *titleV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_select_title.png"]];
    titleV.center = CGPointMake(self.view.centerX, kGSize.height * 0.22);
    [self.view addSubview:titleV];
    
    //scrollview
    UIImage *image = [UIImage imageNamed:@"home_question0.png"];
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, (kGSize.height - image.size.height) / 2 + 25, kGSize.width, image.size.height)];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    int pageIndex = 0;
    while (1) {
        NSString *name = [NSString stringWithFormat:@"%@%d.png", @"home_question", pageIndex];
        UIImage *image = [UIImage imageNamed:name];
        if (image) {
            UIImageView *imgView = [[UIImageView alloc]initWithImage:image];
            if (kIPhone6) {
                float scale = kGSize.width / imgView.width;
                imgView.transform = CGAffineTransformMakeScale(scale, scale);
            }
            imgView.center = CGPointMake(pageIndex * kGSize.width + kGSize.width / 2, _scrollView.height / 2);
            [_scrollView addSubview:imgView];
            
            pageIndex++;
        } else {
            break;
        }
    }
    
    _scrollView.contentSize  = CGSizeMake(pageIndex * kGSize.width, image.size.height);
    _scrollView.contentOffset  = CGPointMake(0, 0);
    
    //pagecontrol
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_scrollView.frame) + 15, kGSize.width, 20)];
    _pageControl.currentPage = 0;
    _pageControl.numberOfPages = pageIndex;
    [self.view addSubview:_pageControl];
    
    //tap gesture
    UITapGestureRecognizer *tapTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectQuestion)];
    [_scrollView addGestureRecognizer:tapTouch];
}

- (void)selectQuestion {
    if (_pageControl.currentPage == 0) {
        KSBQuestionSelectVC *questionVC = [[KSBQuestionSelectVC alloc] init];
        [self.navigationController pushViewController:questionVC animated:YES];
    }
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
