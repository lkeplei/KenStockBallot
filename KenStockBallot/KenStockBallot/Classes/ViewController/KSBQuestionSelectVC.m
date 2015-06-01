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
    UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"question_title.png"]];
    bgView.center = CGPointMake(bgView.width / 2, kGSize.height * 0.2);
    [self.view addSubview:bgView];
    
    UIImage *image = [UIImage imageNamed:@"question_1.png"];
    UIButton *question1 = [KenUtils buttonWithImg:nil off:0 zoomIn:NO image:image
                                        imagesec:[UIImage imageNamed:@"question_1_sec.png"]
                                          target:self action:@selector(question1Selected)];
    question1.center = CGPointMake(self.view.centerX, CGRectGetMaxY(bgView.frame) + image.size.height / 2 + 20);
    [self.view addSubview:question1];
    
    UIButton *question2 = [KenUtils buttonWithImg:nil off:0 zoomIn:NO image:[UIImage imageNamed:@"question_2.png"]
                              imagesec:[UIImage imageNamed:@"question_2_sec.png"]
                                target:self action:@selector(question2Selected)];
    question2.center = CGPointMake(self.view.centerX, CGRectGetMaxY(question1.frame) + image.size.height / 2 + 20);
    [self.view addSubview:question2];
}

#pragma mark - button
- (void)question1Selected {
    KSBMainCalculateVC *calculateVC = [[KSBMainCalculateVC alloc] initWithCalculateType:kKSBCalculateQuestion1];
    [self.navigationController pushViewController:calculateVC animated:YES];
}

- (void)question2Selected {
    KSBMainCalculateVC *calculateVC = [[KSBMainCalculateVC alloc] initWithCalculateType:kKSBCalculateQuestion2];
    [self.navigationController pushViewController:calculateVC animated:YES];
}
@end
