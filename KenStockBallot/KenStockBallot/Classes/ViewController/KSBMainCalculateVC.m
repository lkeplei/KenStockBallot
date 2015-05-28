//
//  KSBMainCalculateVC.m
//  KenStockBallot
//
//  Created by ken on 15/5/27.
//  Copyright (c) 2015年 ken. All rights reserved.
//

#import "KSBMainCalculateVC.h"
#import "KSBEditAddV.h"
#import "KSBStockInfo.h"

@interface KSBMainCalculateVC ()

@property (assign) NSInteger selectedIndex;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UITableView *stockTable;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, readonly) KSBCalculateType calculateType;

@end

@implementation KSBMainCalculateVC

- (instancetype)initWithCalculateType:(KSBCalculateType)type {
    self = [super init];
    if (self) {
        self.title = KenLocal(@"app_title");
        [self.view setBackgroundColor:[UIColor grayBgColor]];
        [self setRightNavItemWithImage:[UIImage imageNamed:@"question_edit.png"]
                                imgSec:[UIImage imageNamed:@"question_edit_sec.png"] selector:@selector(editStock)];
        
        _calculateType = type;
        _selectedIndex = 0;
        _dataArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self initTopV];
    [self initBottomV];
    [self initStockTable];
}

- (void)initTopV {
    _topView = [[UIView alloc] initWithFrame:(CGRect){0, kAppViewOrginY, kGSize.width, _calculateType == kKSBCalculateQuestion1 ? 44 : 88}];
    [_topView setBackgroundColor:[UIColor grayBgColor]];
    [self.view addSubview:_topView];
    
    float offY = 0;
    if (_calculateType == kKSBCalculateQuestion2) {
        UIView *inputV = [[UIView alloc] initWithFrame:(CGRect){0, offY, _topView.width, 44}];
        [inputV setBackgroundColor:[UIColor whiteColor]];
        [_topView addSubview:inputV];
        
        offY += 44;
    }
    UIView *titleV = [[UIView alloc] initWithFrame:(CGRect){0, offY, _topView.width, 44}];
    [titleV setBackgroundColor:[UIColor grayBgColor]];
    [_topView addSubview:titleV];
    
    NSArray *titleArr = @[KenLocal(@"question_title1"), KenLocal(@"question_title2"), KenLocal(@"question_title3"),
                          KenLocal(@"question_title4"), KenLocal(@"question_title5")];
    float width = kGSize.width / [titleArr count];
    for (int i = 0; i < [titleArr count]; i++) {
        UILabel *label = [KenUtils labelWithTxt:titleArr[i] frame:(CGRect){width * i, 0, width, 44}
                                           font:kKenFontHelvetica(12) color:[UIColor greenTextColor]];
        label.numberOfLines = i == ([titleArr count] - 1) ? 2 : 1;
        [titleV addSubview:label];
    }
}

- (void)initStockTable {
    CGRect rect = CGRectMake(0, CGRectGetMaxY(_topView.frame), kGSize.width, _bottomView.originY - CGRectGetMaxY(_topView.frame));
    _stockTable = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    _stockTable.delegate = self;
    _stockTable.dataSource = self;
    [_stockTable setBackgroundColor:[UIColor grayBgColor]];
    _stockTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_stockTable];
}

- (void)initBottomV {
    _bottomView = [[UIView alloc] initWithFrame:(CGRect){0, kGSize.height - 118, kGSize.width, 118}];
    [_bottomView setBackgroundColor:[UIColor grayBgColor]];
    [self.view addSubview:_bottomView];
    
    UIButton *autoBtn = [KenUtils buttonWithImg:KenLocal(@"question_auto_add") off:0 zoomIn:YES
                                          image:[UIImage imageNamed:@"auto_add.png"]
                                       imagesec:[UIImage imageNamed:@"auto_add.png"] target:self action:@selector(autoAdd)];
    [autoBtn setBackgroundColor:[UIColor whiteColor]];
    [autoBtn setTitleColor:[UIColor greenTextColor] forState:UIControlStateNormal];
    autoBtn.frame = CGRectMake(0, 15, _bottomView.width / 2, 44);
    [_bottomView addSubview:autoBtn];
    
    UIButton *manualBtn = [KenUtils buttonWithImg:KenLocal(@"qusstion_manual_add") off:0 zoomIn:YES
                                            image:[UIImage imageNamed:@"manual_add.png"]
                                         imagesec:[UIImage imageNamed:@"manual_add.png"] target:self action:@selector(manualAdd)];
    [manualBtn setBackgroundColor:[UIColor whiteColor]];
    [manualBtn setTitleColor:[UIColor greenTextColor] forState:UIControlStateNormal];
    manualBtn.frame = CGRectMake(CGRectGetMaxX(autoBtn.frame), autoBtn.originY, _bottomView.width / 2, 44);
    [_bottomView addSubview:manualBtn];
    
    UIButton *calculateBtn = [KenUtils buttonWithImg:KenLocal(@"question_calculate") off:0 zoomIn:NO image:nil
                                         imagesec:nil target:self action:@selector(calculateBtn)];
    [calculateBtn.titleLabel setFont:kKenFontHelvetica(16)];
    calculateBtn.frame = CGRectMake(0, _bottomView.height - 44, _bottomView.width, 44);
    [calculateBtn setBackgroundColor:[UIColor greenTextColor]];
    [_bottomView addSubview:calculateBtn];
}

#pragma mark - button
- (void)editStock {
    
}

- (void)autoAdd {
    
}

- (void)manualAdd {
    [self showEidtAddView:nil];
}

- (void)calculateBtn {
    
}

- (void)showEidtAddView:(KSBStockInfo *)info {
    KSBEditAddV *editV = [[KSBEditAddV alloc] initWithStock:info];
    [SysDelegate.window addSubview:editV];
    [editV showContent];
    
    __weak KSBMainCalculateVC *retSelf = self;
    editV.addBlock = ^(KSBStockInfo *info) {
        [[retSelf dataArray] addObject:info];
        [[retSelf stockTable] reloadData];
    };
    
    editV.editBlock = ^(KSBStockInfo *info) {
        if (_selectedIndex < [_dataArray count]) {
            [[retSelf dataArray] replaceObjectAtIndex:_selectedIndex withObject:info];
            [[retSelf stockTable] reloadData];
        }
    };
}

#pragma mark - Table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *bankCellIdentifier = @"videoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:bankCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:bankCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView setBackgroundColor:[UIColor whiteColor]];
    }
    
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectedIndex = indexPath.row;
    [self showEidtAddView:_dataArray[_selectedIndex]];
}

@end
