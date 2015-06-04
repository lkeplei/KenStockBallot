//
//  KSBQuestionSelectVC.m
//  KenStockBallot
//
//  Created by ken on 15/5/27.
//  Copyright (c) 2015年 ken. All rights reserved.
//

#import "KSBQuestionSelectVC.h"
#import "KSBMainCalculateVC.h"

@interface KSBQuestionSelectVC ()

@end

@implementation KSBQuestionSelectVC

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = KenLocal(@"app_title");
        [self.view setBackgroundColor:[UIColor grayBgColor]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImage *titleImg = [UIImage imageNamed:@"question_title.png"];
    UIView *bgView = [[UIView alloc] initWithFrame:(CGRect){0, kAppViewOrginY + kGSize.height * 0.05, kGSize.width, titleImg.size.height * 2}];
    [bgView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:bgView];
    
    UIImage *image = [UIImage imageNamed:@"question_1.png"];
    
    UIImageView *titleView = [[UIImageView alloc] initWithImage:titleImg];
    titleView.origin = CGPointMake((kGSize.width - image.size.width) / 2, titleImg.size.height / 2);
    [bgView addSubview:titleView];
    
    UIButton *question1 = [KenUtils buttonWithImg:nil off:0 zoomIn:NO image:image
                                        imagesec:[UIImage imageNamed:@"question_1_sec.png"]
                                          target:self action:@selector(question1Selected)];
    question1.center = CGPointMake(self.view.centerX, CGRectGetMaxY(bgView.frame) + image.size.height / 2 + 55);
    [self.view addSubview:question1];
    
    UIButton *question2 = [KenUtils buttonWithImg:nil off:0 zoomIn:NO image:[UIImage imageNamed:@"question_2.png"]
                              imagesec:[UIImage imageNamed:@"question_2_sec.png"]
                                target:self action:@selector(question2Selected)];
    question2.center = CGPointMake(self.view.centerX, CGRectGetMaxY(question1.frame) + image.size.height / 2 + 30);
    [self.view addSubview:question2];
}

#pragma mark - button
- (void)question1Selected {
    KSBMainCalculateVC *calculateVC = [[KSBMainCalculateVC alloc] initWithCalculateType:kKSBCalculateQuestion1];
    [self pushViewController:calculateVC];
}

- (void)question2Selected {
    KSBMainCalculateVC *calculateVC = [[KSBMainCalculateVC alloc] initWithCalculateType:kKSBCalculateQuestion2];
    [self pushViewController:calculateVC];
}
@end
