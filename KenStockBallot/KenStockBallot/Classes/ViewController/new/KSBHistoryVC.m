//
//  KSBHistoryVC.m
//  KenStockBallot
//
//  Created by hzyouda on 2016/12/24.
//  Copyright © 2016年 ken. All rights reserved.
//

#import "KSBHistoryVC.h"
#import "KSBHistoryInfo.h"

#import <BmobSDK/Bmob.h>

static const int cellEitOffX = 20;

#import "BaiduMobAdSDK/BaiduMobAdSetting.h"
#import "BaiduMobAdSDK/BaiduMobAdView.h"
#import "BaiduMobAdSDK/BaiduMobAdDelegateProtocol.h"

@interface KSBHistoryVC ()<UITableViewDataSource, UITableViewDelegate, BaiduMobAdViewDelegate>

@property (nonatomic, strong) UITableView *stockTable;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *preDataArray;

@property (nonatomic, strong) BaiduMobAdView *sharedAdView;

@end

@implementation KSBHistoryVC
- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = KenLocal(@"app_history_title");
        
        [self setData:[[KSBModel shareKSBModel] getHistory]];
        
        [self.view setBackgroundColor:[UIColor grayBgColor]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView *topView = [[UIView alloc] initWithFrame:(CGRect){0, kAppViewOrginY, kGSize.width, 44}];
    [topView setBackgroundColor:[UIColor grayBgColor]];
    [self.view addSubview:topView];
    
    UIView *titleV = [[UIView alloc] initWithFrame:(CGRect){0, 0, topView.width, 44}];
    [titleV setBackgroundColor:[UIColor grayBgColor]];
    [topView addSubview:titleV];
    
    //title
    NSArray *titleArr = @[KenLocal(@"question_title1"), KenLocal(@"question_title3"), @"累计申购\n新股次数",
                          @"中签时的\n累积概率", KenLocal(@"question_title6")];
    float width = (kGSize.width - cellEitOffX) / [titleArr count];
    for (int i = 0; i < [titleArr count]; i++) {
        UILabel *label = [KenUtils labelWithTxt:titleArr[i]
                                          frame:(CGRect){cellEitOffX + width * i, 0, width, 44}
                                           font:kKenFontHelvetica(14) color:[UIColor greenTextColor]];
        label.numberOfLines = 0;
        [titleV addSubview:label];
    }
    
    //table
    CGRect rect = CGRectMake(0, CGRectGetMaxY(topView.frame), kGSize.width, self.view.height - CGRectGetMaxY(topView.frame));
    _stockTable = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    _stockTable.delegate = self;
    _stockTable.dataSource = self;
    [_stockTable setBackgroundColor:[UIColor grayBgColor]];
    _stockTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_stockTable];
    
    [_stockTable reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.sharedAdView removeFromSuperview];
    self.sharedAdView = nil;
    
    [self.view addSubview:self.sharedAdView];
}

- (void)setData:(NSArray *)array {
    if (_dataArray) {
        [_dataArray removeAllObjects];
    } else {
        _dataArray = [NSMutableArray array];
    }
    [_dataArray addObjectsFromArray:array];
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
    
    KSBHistoryInfo *info = _dataArray[indexPath.row];
    NSArray *array = @[info.name, info.price, info.times, info.ballot, info.date];
    float width = (kGSize.width - cellEitOffX) / [array count];
    for (int i = 0; i < [array count]; i++) {
        float height = i == 0 ? cell.height * 0.4 : cell.height;
        UILabel *label = [KenUtils labelWithTxt:array[i] frame:(CGRect){cellEitOffX + width * i, i == 0 ? cell.height * 0.15 : 0, width, height}
                                           font:kKenFontHelvetica(14) color:[UIColor blackTextColor]];
        [cell.contentView addSubview:label];
        if (i == 0) {
//            label.textAlignment = KTextAlignmentLeft;
            
            NSString *image = @"new_hu";
            if ([info.jiaoYS isEqual:@"深圳"]) {
                image = @"new_sheng";
            }
            CGFloat codeWidth = [KenUtils getFontSize:info.code font:kKenFontHelvetica(12)].width + 4;
            
            UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]];
            imgV.originX = label.originX + (width - codeWidth - imgV.width) / 2;
            [cell.contentView addSubview:imgV];
            
            UILabel *code = [KenUtils labelWithTxt:info.code
                                             frame:(CGRect){CGRectGetMaxX(imgV.frame) + 4, cell.height * 0.5, codeWidth, height}
                                              font:kKenFontHelvetica(12) color:[UIColor grayTextColor]];
            code.textAlignment = KTextAlignmentLeft;
            [cell.contentView addSubview:code];
            
            imgV.centerY = code.centerY;
        }
    }
    
    UIView *line = [[UIView alloc] initWithFrame:(CGRect){cellEitOffX, cell.height - 1, kGSize.width, 1}];
    [line setBackgroundColor:[UIColor separatorMainColor]];
    [cell.contentView addSubview:line];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark - baidu delegate
- (NSString *)publisherId {
    return kBaiduPublisherId; //@"your_own_app_id";注意，iOS和android的app请使用不同的app ID
}

- (BOOL)enableLocation {
    //启用location会有一次alert提示
    return YES;
}

- (void)willDisplayAd:(BaiduMobAdView*)adview {
    NSLog(@"delegate: will display ad");
}

- (void)failedDisplayAd:(BaiduMobFailReason)reason {
    NSLog(@"delegate: failedDisplayAd %d", reason);
}

- (void)didAdImpressed {
    NSLog(@"delegate: didAdImpressed");
    
}

- (void)didAdClicked {
    NSLog(@"delegate: didAdClicked");
}

- (void)didAdClose {
    NSLog(@"delegate: didAdClose");
}

#pragma mark - getter setter
#define kScreenWidth self.view.frame.size.width
#define kScreenHeight self.view.frame.size.height
- (BaiduMobAdView *)sharedAdView {
    if (_sharedAdView == nil) {
        //lp颜色配置
        [BaiduMobAdSetting setLpStyle:BaiduMobAdLpStyleDefault];
#warning ATS默认开启状态, 可根据需要关闭App Transport Security Settings，设置关闭BaiduMobAdSetting的supportHttps，以请求http广告，多个产品只需要设置一次.    [BaiduMobAdSetting sharedInstance].supportHttps = NO;
        
        //使用嵌入广告的方法实例。
        _sharedAdView = [[BaiduMobAdView alloc] init];
        _sharedAdView.AdUnitTag = @"3191691";
        _sharedAdView.AdType = BaiduMobAdViewTypeBanner;
        CGFloat bannerY = kScreenHeight - 0.15 * kScreenWidth;
        _sharedAdView.frame = CGRectMake(0, bannerY, kScreenWidth, 0.15*kScreenWidth);
        
        _sharedAdView.delegate = self;
        [_sharedAdView start];
    }
    return _sharedAdView;
}
@end
