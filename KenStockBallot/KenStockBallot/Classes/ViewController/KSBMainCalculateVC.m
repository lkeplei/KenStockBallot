//
//  KSBMainCalculateVC.m
//  KenStockBallot
//
//  Created by ken on 15/5/27.
//  Copyright (c) 2015年 ken. All rights reserved.
//

#import "KSBMainCalculateVC.h"

@interface KSBMainCalculateVC ()

@property (nonatomic, strong) UITableView *stockTable;

@end

@implementation KSBMainCalculateVC

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
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self initTopV];
    [self initStockTable];
    [self initBottomV];
}

- (void)initTopV {
    
}

- (void)initStockTable {
    CGRect rect = CGRectMake(0, kAppViewOrginY, kGSize.width,
                             kGSize.height - kAppViewOrginY - kAppTabbarHeight);
    _stockTable = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    _stockTable.delegate = self;
    _stockTable.dataSource = self;
    [_stockTable setBackgroundColor:[UIColor separatorColor]];
    _stockTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_stockTable];
}

- (void)initBottomV {
    
}
@end
