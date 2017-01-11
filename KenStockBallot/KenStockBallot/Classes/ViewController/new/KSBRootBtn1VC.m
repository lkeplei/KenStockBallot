//
//  KSBRootBtn1VC.m
//  KenStockBallot
//
//  Created by hzyouda on 2016/12/24.
//  Copyright © 2016年 ken. All rights reserved.
//

#import "KSBRootBtn1VC.h"
#import "KSBEditAddV.h"
#import "KSBStockInfo.h"
#import "KSBCalculateQuestion1V.h"
#import "KSBCalculateQuestion2V.h"
#import "KSBCalculateEditVC.h"

#import "GoogleMobileAds/GoogleMobileAds.h"

static const int cellOffX = 20;

@interface KSBRootBtn1VC ()<GADInterstitialDelegate>

@property (assign) NSInteger selectedIndex;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UITableView *stockTable;
@property (nonatomic, strong) UITextField *totalMoneyTextField;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, readonly) KSBCalculateType calculateType;

@property (assign) BOOL editStatus;

@property (nonatomic, strong) GADInterstitial *interstitial;
@property (nonatomic, strong) KSBCalculateBaseV *resultView;

@end

@implementation KSBRootBtn1VC

- (instancetype)init {
    self = [super init];
    if (self) {
        _calculateType = kKSBCalculateQuestion1;
        _selectedIndex = 0;
        _dataArray = [NSMutableArray array];
        _editStatus = NO;

        [self.view setBackgroundColor:[UIColor grayBgColor]];
        [self setRightNavItemWithImage:[UIImage imageNamed:@"question_edit.png"]
                                imgSec:[UIImage imageNamed:@"question_edit_sec.png"] selector:@selector(editStock)];
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
    
    //tap gesture
    UITapGestureRecognizer *tapTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tapTouch.delegate = self;
    [self.view addGestureRecognizer:tapTouch];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSArray *array = [[KSBModel shareKSBModel] getStock:_calculateType];
    if ([KenUtils isNotEmpty:array]) {
        [_dataArray removeAllObjects];
        [_dataArray addObjectsFromArray:array];
        [_stockTable reloadData];
    }
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
        
        UIImageView *moneyLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"money_logo.png"]];
        moneyLogo.center = CGPointMake(moneyLogo.width / 2 + 8, inputV.height / 2);
        [inputV addSubview:moneyLogo];
        
        UILabel *label = [KenUtils labelWithTxt:KenLocal(@"question_label") frame:(CGRect){CGRectGetMaxX(moneyLogo.frame) + 4, 0, 124, inputV.height}
                                           font:kKenFontHelvetica(15) color:[UIColor blackTextColor]];
        [inputV addSubview:label];
        
        //text field
        _totalMoneyTextField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label.frame) + 4, 4, 130, inputV.height - 8)];
        _totalMoneyTextField.font = kKenFontArial(14);
        _totalMoneyTextField.clearButtonMode = UITextFieldViewModeAlways;
        _totalMoneyTextField.clearsOnBeginEditing = NO;
        _totalMoneyTextField.textAlignment = KTextAlignmentLeft;
        _totalMoneyTextField.returnKeyType = UIReturnKeyDone;
        _totalMoneyTextField.delegate = self;
        _totalMoneyTextField.keyboardType = UIKeyboardTypeDecimalPad;
        [_totalMoneyTextField setBorderStyle:UITextBorderStyleRoundedRect];
        [inputV addSubview:_totalMoneyTextField];
        
        UILabel *unit = [KenUtils labelWithTxt:KenLocal(@"edit_yuan")
                                         frame:(CGRect){CGRectGetMaxX(_totalMoneyTextField.frame), 0, 24, inputV.height}
                                          font:kKenFontHelvetica(16) color:[UIColor blackTextColor]];
        [inputV addSubview:unit];
        
        offY += 44;
    }
    UIView *titleV = [[UIView alloc] initWithFrame:(CGRect){0, offY, _topView.width, 44}];
    [titleV setBackgroundColor:[UIColor grayBgColor]];
    [_topView addSubview:titleV];
    
    NSArray *titleArr = @[KenLocal(@"question_title1"), KenLocal(@"question_title3"),
                          _calculateType == kKSBCalculateQuestion1 ? KenLocal(@"question_title4") : KenLocal(@"question_title4_2"),
                          KenLocal(@"question_title5"), KenLocal(@"question_title6")];
    float width = (kGSize.width - cellOffX) / [titleArr count];
    for (int i = 0; i < [titleArr count]; i++) {
        UILabel *label = [KenUtils labelWithTxt:titleArr[i]
                                          frame:(CGRect){cellOffX + width * i, 0, (i == 0 ? width - 26 : width), 44}
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
    
    UIView *line = [[UIView alloc] initWithFrame:(CGRect){_bottomView.width / 2, autoBtn.originY + 8, 1, 28}];
    [line setBackgroundColor:[UIColor separatorMainColor]];
    [_bottomView addSubview:line];
    
    UIButton *calculateBtn = [KenUtils buttonWithImg:KenLocal(@"question_calculate") off:0 zoomIn:NO image:nil
                                            imagesec:nil target:self action:@selector(calculateBtn)];
    [calculateBtn.titleLabel setFont:kKenFontHelvetica(16)];
    calculateBtn.frame = CGRectMake(0, _bottomView.height - 44, _bottomView.width, 44);
    [calculateBtn setBackgroundImage:[UIImage imageNamed:@"calculate_bg"] forState:UIControlStateNormal];
    [calculateBtn setBackgroundImage:[UIImage imageNamed:@"calculate_bg_sec"] forState:UIControlStateHighlighted];
    [calculateBtn setBackgroundImage:[UIImage imageNamed:@"calculate_bg_sec"] forState:UIControlStateSelected];
    [_bottomView addSubview:calculateBtn];
}

#pragma mark - textField
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

- (void)hideKeyboard {
    [_totalMoneyTextField resignFirstResponder];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([_totalMoneyTextField isFirstResponder]) {
        return YES;
    }
    return NO;
}

#pragma mark - button
- (void)editStock {
    if ([_dataArray count] > 0) {
        KSBCalculateEditVC *editVC = [[KSBCalculateEditVC alloc] initWithStock:_dataArray questionType:_calculateType add:NO];
        [self pushViewController:editVC];
    }
}

- (void)autoAdd {
    KSBCalculateEditVC *editVC = [[KSBCalculateEditVC alloc] initWithStock:_dataArray questionType:_calculateType add:YES];
    [self pushViewController:editVC];
}

- (void)manualAdd {
    [self showEidtAddView:nil];
}

- (void)calculateBtn {
    if (_calculateType == kKSBCalculateQuestion1) {
        [self showFullAD];
        
        _resultView = [[KSBCalculateQuestion1V alloc] initWithStockArray:_dataArray money:nil];
        _resultView.parentVC = self;
    } else if (_calculateType == kKSBCalculateQuestion2) {
        if ([[_totalMoneyTextField text] length] <= 0) {
            kKenAlert(KenLocal(@"question_alert"));
        } else {
            _resultView = [[KSBCalculateQuestion2V alloc] initWithStockArray:_dataArray money:[_totalMoneyTextField text]];
        }
    }
    
    [SysDelegate.window addSubview:_resultView];
    [_resultView showContent];
}

- (void)showEidtAddView:(KSBStockInfo *)info {
    KSBEditAddV *editV = [[KSBEditAddV alloc] initWithStock:info calculateType:_calculateType];
    [SysDelegate.window addSubview:editV];
    [editV showContent];
    
    @weakify(self)
    editV.addBlock = ^(KSBStockInfo *info) {
        @strongify(self)
        [[self dataArray] addObject:info];
        [[self stockTable] reloadData];
        
        [[KSBModel shareKSBModel] saveStock:[self dataArray] type:_calculateType];
    };
    
    editV.editBlock = ^(KSBStockInfo *info) {
        @strongify(self)
        if (_selectedIndex < [_dataArray count]) {
            [[self dataArray] replaceObjectAtIndex:_selectedIndex withObject:info];
            [[self stockTable] reloadData];
            
            [[KSBModel shareKSBModel] saveStock:[self dataArray] type:_calculateType];
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
    
    KSBStockInfo *info = _dataArray[indexPath.row];
    NSArray *array = @[info.stockName,
                       [NSString stringWithFormat:@"%.2f%@", info.stockPrice, KenLocal(@"edit_yuan")],
                       [NSString stringWithFormat:@"%d%@", (int)info.stockBuyMax, KenLocal(@"edit_gu")],
                       [NSString stringWithFormat:@"%.4f%%", info.stockBallot], info.stockDate];
    float width = (kGSize.width - cellOffX) / [array count];
    for (int i = 0; i < [array count]; i++) {
        float height = i == 0 ? cell.height * 0.4 : cell.height;
        UILabel *label = [KenUtils labelWithTxt:array[i] frame:(CGRect){cellOffX + width * i, i == 0 ? cell.height * 0.15 : 0, width, height}
                                           font:kKenFontHelvetica(12) color:[UIColor blackTextColor]];
        [cell.contentView addSubview:label];
        if (i == 0) {
            label.textAlignment = KTextAlignmentLeft;
            
            NSString *image = @"new_hu";
            if ([info.stockJiaoYS isEqual:@"深圳"]) {
                image = @"new_sheng";
            }
            UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]];
            imgV.originX = label.originX;
            [cell.contentView addSubview:imgV];
            
            UILabel *code = [KenUtils labelWithTxt:info.stockCode
                                             frame:(CGRect){cellOffX + imgV.width + 4, cell.height * 0.5, width, height}
                                              font:kKenFontHelvetica(12) color:[UIColor grayTextColor]];
            code.textAlignment = KTextAlignmentLeft;
            [cell.contentView addSubview:code];
            
            imgV.centerY = code.centerY;
        }
    }
    
    UIView *line = [[UIView alloc] initWithFrame:(CGRect){cellOffX, cell.height - 1, kGSize.width, 1}];
    [line setBackgroundColor:[UIColor separatorMainColor]];
    [cell.contentView addSubview:line];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectedIndex = indexPath.row;
    [self showEidtAddView:_dataArray[_selectedIndex]];
}

#pragma mark - private method
- (void)showFullAD {
    //显示全屏广告
    _interstitial = [[GADInterstitial alloc] initWithAdUnitID:@"ca-app-pub-3782605513789953/8724243825"];
    _interstitial.delegate = self;
    
    [_interstitial loadRequest:[GADRequest request]];
}

#pragma mark - admob delegate
- (void)interstitialDidReceiveAd:(GADInterstitial *)ad {
    if (self.interstitial.isReady) {
        [self.interstitial presentFromRootViewController:self];
    }
}

- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error {
    [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(showFullAD) userInfo:nil repeats:NO];
}

#pragma mark Display-Time Lifecycle Notifications
- (void)interstitialWillPresentScreen:(GADInterstitial *)ad {
    _resultView.hidden = YES;
}

- (void)interstitialDidFailToPresentScreen:(GADInterstitial *)ad {
    
}

- (void)interstitialWillDismissScreen:(GADInterstitial *)ad {
    
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)ad {
    _resultView.hidden = NO;
}

- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad {
    
}
@end
